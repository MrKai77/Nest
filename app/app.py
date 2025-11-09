import uuid

from fastapi import FastAPI, Body
from fastapi.responses import PlainTextResponse

from pydantic import BaseModel
from typing import List, Optional
from schemas import *
from database_interactions import search_listings_in_db

app = FastAPI()


@app.get("/ping", response_class=PlainTextResponse)
def ping():
    return "Hello world"

@app.post("/search_listings", response_model=ListingsResponse)
def search_listings(request: SearchRequest):
    db_listings: list[DatabaseListing] = search_listings_in_db(request)

    listings: list[Listing] = [
        Listing(**db_listing.dict(exclude={"weighted_score", "id", ""}))
        for db_listing in db_listings
    ]

    return ListingsResponse(listings=listings)