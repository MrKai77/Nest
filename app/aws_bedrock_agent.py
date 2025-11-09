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
        parts: list[str] = []

        # natural language part
        if listing.description:
            parts.append(f"Description: {listing.description}")

        # numeric/structured fields
        parts.append(f"Price: {listing.price}")
        parts.append(f"Location: lat {listing.latitude}, lon {listing.longitude}")
        parts.append(f"Address: {listing.address}")

        if listing.square_footage is not None:
            parts.append(f"Square footage: {listing.square_footage}")
        if listing.bedrooms_num is not None:
            parts.append(f"Bedrooms: {listing.bedrooms_num}")
        if listing.bathroom_num is not None:
            parts.append(f"Bathrooms: {listing.bathroom_num}")
        if listing.backyard is not None:
            parts.append("Has backyard" if listing.backyard else "No backyard")
        if listing.garage is not None:
            parts.append("Has garage" if listing.garage else "No garage")

        return ", ".join(parts)

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
        

    
bedrock_embedding_agent = awsBedrockAgent()