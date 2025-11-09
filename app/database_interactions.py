import os
import json
from typing import Any, Dict, List, Optional, Union
from supabase import create_client, Client
from schemas import DatabaseListing, SearchRequest, CreateListingRequest
from aws_bedrock_agent import bedrock_embedding_agent
from postgrest.exceptions import APIError

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_KEY = os.environ["SUPABASE_KEY"]

if not SUPABASE_URL or not SUPABASE_KEY:
    raise RuntimeError(
        "SUPABASE_URL or SUPABASE_KEY is not set. "
        "Set them in the environment before starting the app."
    )

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)

def insert_listing_with_agent(payload: CreateListingRequest) -> DatabaseListing:
    return bedrock_embedding_agent.encode_and_store_listing(payload)

def _fake_listing_from_search(req: SearchRequest) -> CreateListingRequest:

    #for price, pick a representative value in the range if possible
    if req.min_price is not None and req.max_price is not None:
        price = (req.min_price + req.max_price) / 2
    else:
        price = req.min_price or req.max_price or 0.0

    return CreateListingRequest(
        price=price,
        date_listed="1970-01-01T00:00:00Z",  # not used in embedding
        image_url=None,
        description=req.description,
        longitude=req.longitude,
        latitude=req.latitude,
        address=req.address,
        square_footage=req.square_footage,
        bathroom_num=req.bathroom_num,
        bedrooms_num=req.bedrooms_num,
        backyard=req.backyard,
        garage=req.garage,
    )

def search_listings_in_db(req: SearchRequest, limit: int = 20) -> List[DatabaseListing]:
    
    print("Searching listings in DB with request:", req)

    # Build 'query listing' and get embedding from Bedrock
    query_listing = _fake_listing_from_search(req)
    query_embedding = bedrock_embedding_agent.get_embedding(query_listing)

    # Compute a loose lat/lon bounding box around the user's point
    LAT_DELTA = 0.2
    LON_DELTA = 0.2
    min_lat = req.latitude - LAT_DELTA
    max_lat = req.latitude + LAT_DELTA
    min_lon = req.longitude - LON_DELTA
    max_lon = req.longitude + LON_DELTA

    # Call the RPC function
    match_threshold = 0.30  # tune this (0–1)

    query = supabase.rpc(
        "match_listings_with_filters",
        {
            "query_embedding": query_embedding,
            "match_threshold": match_threshold,
            "match_count": limit,
            "min_price": req.min_price,
            "max_price": req.max_price,
            "min_lat": min_lat,
            "max_lat": max_lat,
            "min_lon": min_lon,
            "max_lon": max_lon,
        },
    )

    try:
        resp = query.execute()
    except APIError as e:
        raise RuntimeError(f"Supabase query error: {e}") from e
    
    raw_rows: Any = resp.data or []
    # Coerce only list-of-dict payloads; otherwise treat as empty list
    rows: List[Dict[str, Any]] = raw_rows if isinstance(raw_rows, list) else []

    clean_rows: List[Dict[str, Any]] = []
    for row in rows:
        ws: Optional[Union[str, List[float]]] = row.get("weighted_score")
        if isinstance(ws, str):
            try:
                row["weighted_score"] = json.loads(ws)
            except json.JSONDecodeError:
                row["weighted_score"] = []
        clean_rows.append(row)

    listings: List[DatabaseListing] = [
        DatabaseListing(**{k: v for k, v in row.items() if k != "similarity"})
        for row in clean_rows
    ]

    return listings

def delete_listing_in_db(listing_id: str) -> bool:
    
    try:
        resp = supabase.table("listings").delete().eq("id", listing_id).execute()
    except APIError as e:
        raise RuntimeError(f"Supabase delete error: {e}") from e

    return bool(resp.data)




