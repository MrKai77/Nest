import os
import json
import uuid
from typing import Any, Dict, List, Optional, Union
import boto3
from postgrest.exceptions import APIError

from supabase import create_client, Client
from schemas import CreateListingRequest, DatabaseListing


class awsBedrockAgent:
    def __init__(self,
                  model_id: Optional[str] = None, 
                  region: Optional[str] = None,
                  supabase_url: Optional[str] = None,
                  supabase_key: Optional[str] = None
                  ):
        self.model_id = model_id or os.environ.get("BEDROCK_EMBEDDING_MODEL_ID", "amazon.titan-embed-text-v2:0")
        self.region = region or os.environ.get("AWS_REGION", "us-east-2")

        self.client = boto3.client("bedrock-runtime", region_name=self.region)
        url = supabase_url or os.environ["SUPABASE_URL"]
        key = supabase_key or os.environ["SUPABASE_KEY"]
        self.supabase: Client = create_client(url, key)
        

    def _build_input_text(self, listing: CreateListingRequest) -> str:
        def yn(v: Optional[bool]) -> Optional[str]:
            if v is None:
                return None
            return "yes" if v else "no"

        # Priority is location and core structured features
        priority_parts: list[str] = []
        priority_parts.append(f"location lat:{listing.latitude:.6f} lon:{listing.longitude:.6f}")
        priority_parts.append(f"price:{listing.price}")

        if listing.bedrooms_num is not None:
            priority_parts.append(f"bedrooms:{listing.bedrooms_num}")
        if listing.bathroom_num is not None:
            priority_parts.append(f"bathrooms:{listing.bathroom_num}")
        if listing.square_footage is not None:
            priority_parts.append(f"sqft:{listing.square_footage}")
        by = yn(listing.backyard)
        if by is not None:
            priority_parts.append(f"backyard:{by}")
        gr = yn(listing.garage)
        if gr is not None:
            priority_parts.append(f"garage:{gr}")

        # Light repetition of amenities to boost their influence slightly
        amenity_boost = []
        if listing.bedrooms_num is not None:
            amenity_boost.append(f"bedrooms:{listing.bedrooms_num}")
        if listing.bathroom_num is not None:
            amenity_boost.append(f"bathrooms:{listing.bathroom_num}")
        if listing.square_footage is not None:
            amenity_boost.append(f"sqft:{listing.square_footage}")
        if by is not None:
            amenity_boost.append(f"backyard:{by}")
        if gr is not None:
            amenity_boost.append(f"garage:{gr}")

        # Keep address and description but with lower weight
        context_parts: list[str] = []
        if listing.address:
            # De-emphasize by labeling and not repeating
            context_parts.append(f"address(low): {listing.address}")

        if listing.description:
            desc = listing.description.strip()
            # Truncate to reduce impact of long descriptions
            if len(desc) > 220:
                desc = desc[:220] + "…"
            context_parts.append(f"desc(low): {desc}")

        sections = [
            "PRIORITY " + " | ".join(priority_parts),
        ]
        if amenity_boost:
            sections.append("AMENITIES " + " | ".join(amenity_boost))
        if context_parts:
            sections.append("CONTEXT " + " | ".join(context_parts))

        return " \n ".join(sections)

    def get_embedding(self, listing: CreateListingRequest) -> List[float]:

        input_text = self._build_input_text(listing)

        response = self.client.invoke_model(
            modelId=self.model_id,
            body=json.dumps({"inputText": input_text})
        )

        result = json.loads(response["body"].read())

        if "embedding" in result:
            return result["embedding"]
        elif "vector" in result:
            return result["vector"]
        else:
            raise ValueError("Unexpected embedding response format")
    
    def encode_and_store_listing(self, listing: CreateListingRequest) -> DatabaseListing:
        
        embedding: List[float] = self.get_embedding(listing)
        row: Dict[str, Any] = listing.model_dump(by_alias=True)
        row["weighted_score"] = embedding

        try:
            resp: Any = self.supabase.table("listings").insert(row).execute()
        except APIError as e:
            raise RuntimeError(f"Supabase insert error: {e}") from e
        
        if not resp.data:
            raise RuntimeError("Supabase insert returned no data")

        inserted: Dict[str, Any] = resp.data[0]
        ws: Optional[Union[str, List[float]]] = inserted.get("weighted_score")

        if isinstance(ws, str):
            inserted["weighted_score"] = json.loads(ws)
        return DatabaseListing(**inserted)

    # def regenerate_all_embeddings(self) -> dict[str, Any]:

    #     summary = {"updated": 0, "failed": []}
    #     try:
    #         resp = self.supabase.table("listings").select("*").execute()
    #     except APIError as e:
    #         raise RuntimeError(f"Supabase select error: {e}") from e

    #     rows: list[dict[str, Any]] = resp.data or []
    #     for row in rows:
    #         try:
    #             # Build a CreateListingRequest-like object for embedding reuse
    #             # Required fields (raise if missing)
    #             try:
    #                 price: float = float(row["price"])  # type: ignore[arg-type]
    #                 longitude: float = float(row["longitude"])  # type: ignore[arg-type]
    #                 latitude: float = float(row["latitude"])  # type: ignore[arg-type]
    #                 address: str = str(row["address"])  # type: ignore[arg-type]
    #                 date_listed: str = str(row["date_listed"])  # type: ignore[arg-type]
    #             except KeyError as ke:
    #                 summary["failed"].append(row.get("id", "unknown"))
    #                 continue

    #             req = CreateListingRequest(
    #                 price=price,
    #                 date_listed=date_listed,
    #                 image_url=row.get("image_url"),
    #                 longitude=longitude,
    #                 latitude=latitude,
    #                 address=address,
    #                 square_footage=row.get("square_footage"),
    #                 bathroom_num=row.get("bathroom_num"),
    #                 bedrooms_num=row.get("bedrooms_num"),
    #                 backyard=row.get("backyard"),
    #                 garage=row.get("garage"),
    #                 description=row.get("description"),
    #             )
    #             embedding = self.get_embedding(req)
    #             update_resp = self.supabase.table("listings").update({"weighted_score": embedding}).eq("id", row["id"]).execute()
    #             if update_resp.data:
    #                 summary["updated"] += 1
    #                 try:
    #                     print(f"[{row['id']}] updated")
    #                 except Exception:
    #                     pass
    #             else:
    #                 summary["failed"].append(row["id"])
    #                 try:
    #                     print(f"[{row['id']}] failed update")
    #                 except Exception:
    #                     pass
    #         except Exception as e:  # broad catch per-item
    #             summary["failed"].append(row.get("id", "unknown"))
    #             try:
    #                 rid = row.get("id", "unknown")
    #                 print(f"[{rid}] failed: {e}")
    #             except Exception:
    #                 pass
    #     return summary
    
bedrock_embedding_agent = awsBedrockAgent()