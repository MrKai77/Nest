import os
from typing import List
from supabase import create_client, Client
from schemas import DatabaseListing, SearchRequest

SUPABASE_URL = os.environ["SUPABASE_URL"]
SUPABASE_KEY = os.environ["SUPABASE_KEY"]

supabase: Client = create_client(SUPABASE_URL, SUPABASE_KEY)


def search_listings_in_db(req: SearchRequest) -> List[DatabaseListing]:
    query = (
        supabase.table("listings")
        .select(
            "id, price, date_listed, image_url, longitude, latitude, address, "
            "square_footage, bathroom_num, bedrooms_num, backyard, garage, "
            "weighted_score, updated_at"
        )
    )

    if req.min_price is not None:
        query = query.gte("price", req.min_price)
    if req.max_price is not None:
        query = query.lte("price", req.max_price)


    resp = query.execute()

    if resp.error:
        raise RuntimeError(f"Supabase error: {resp.error}")

    return [DatabaseListing(**row) for row in (resp.data or [])]


