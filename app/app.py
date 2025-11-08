
from fastapi import FastAPI, Body
from fastapi.responses import PlainTextResponse

from pydantic import BaseModel
from typing import List, Optional
from schemas import *

app = FastAPI()


@app.get("/ping", response_class=PlainTextResponse)
def ping():
    return "Hello world"

@app.post("/search_listings", response_model=ListingsResponse)
def search_listings(request: SearchRequest):
    # Sample listings
    sample_listings = [
        Listing(longitude=-122.4194, latitude=37.7749, address="123 Market St, San Francisco, CA"),
        Listing(longitude=-73.935242, latitude=40.73061, address="456 Broadway, New York, NY"),
    ]
    return ListingsResponse(listings=sample_listings)