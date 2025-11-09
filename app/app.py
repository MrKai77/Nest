from dotenv import load_dotenv

# Load environment variables from a local .env file if present
# Must happen BEFORE importing modules that read environment variables at import-time
load_dotenv()

import os
from fastapi import FastAPI, Body, HTTPException, Header
from fastapi.responses import PlainTextResponse


from pydantic import BaseModel
from typing import List, Optional
from schemas import *

from database_interactions import search_listings_in_db, delete_listing_in_db
from aws_bedrock_agent import bedrock_embedding_agent

app = FastAPI()


@app.get("/ping", response_class=PlainTextResponse)
def ping():
    return "Hello world"

@app.post("/create_listing", response_model=Listing)
def create_listing(request: CreateListingRequest):
    db_listing = bedrock_embedding_agent.encode_and_store_listing(request)

    # Strip internal fields (weighted_score, updated_at) from response
    public = Listing(
        **db_listing.model_dump(exclude={"weighted_score", "updated_at"})
    )
    return public

@app.post("/search_listings", response_model=ListingsResponse)
def search_listings(request: SearchRequest):
    db_listings: list[DatabaseListing] = search_listings_in_db(request)

    # Strip internal fields from response (weighted_score, updated_at)
    listings: list[Listing] = [
        Listing(**l.model_dump(exclude={"weighted_score", "updated_at"}))
        for l in db_listings
    ]

    return ListingsResponse(listings=listings)

@app.delete("/listings/{listing_id}", status_code=204)
def delete_listing(listing_id: str):
    """
    Delete a listing by its UUID.
    Returns 204 No Content on success, 404 if not found.
    """
    try:
        deleted = delete_listing_in_db(listing_id)
    except RuntimeError as e:
        # Supabase error
        raise HTTPException(status_code=500, detail=str(e))

    if not deleted:
        raise HTTPException(status_code=404, detail="Listing not found")

    # 204 response: empty body
    return


# Only uncomment when needed, should not be exposed publicly in normal operation
# @app.get("/reembed")
# def regenerate_all_embeddings():
#     """
#     Recompute embeddings for all listings and overwrite weighted_score.
#     """
#     summary = bedrock_embedding_agent.regenerate_all_embeddings()
#     return summary