
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
        Listing(
            longitude=-122.4194,
            latitude=37.7749,
            address="123 Market St, San Francisco, CA",
            price=899000.0,
            date_listed=1731004800,  # 2024-11-07T00:00:00Z
            image_url="https://ap.rdcpix.com/eced95485c361b8ed1106d2a569e5649l-m2131695795rd-w480_h360.webp",
            square_footage=1450,
            bathroom_num=2,
            bedrooms_num=3,
            backyard=True,
            garage=False,
        ),
        Listing(
            longitude=-73.935242,
            latitude=40.73061,
            address="456 Broadway, New York, NY",
            price=1250000.0,
            date_listed=1730928400,  # 2024-11-06T02:26:40Z
            image_url="https://photos.zillowstatic.com/fp/a3e198cd1a154cd3dccc092c57efe2a9-se_medium_500_250.webp",
            square_footage=980,
            bathroom_num=1,
            bedrooms_num=2,
            backyard=False,
            garage=False,
        ),
    ]
    return ListingsResponse(listings=sample_listings)