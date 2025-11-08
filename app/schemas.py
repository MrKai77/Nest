from pydantic import BaseModel, Field
from typing import Optional, List

class Listing(BaseModel):
    longitude: float
    latitude: float
    address: str

class Location(BaseModel):
    address: str
    longitude: float
    latitude: float

class Amenities(BaseModel):
    square_footage: Optional[int] = None
    bathroom_num: Optional[int] = Field(None, alias="bathroom_num")
    bedrooms_num: Optional[int] = Field(None, alias="bedrooms_num")
    backyard: Optional[bool] = None
    garage: Optional[bool] = None

class Price(BaseModel):
    min_price: Optional[float] = None
    max_price: Optional[float] = None

# REQUESTS/RESPONSES

class SearchRequest(BaseModel):
    location: Location
    amenities: Optional[Amenities] = None
    price: Optional[Price] = None

class ListingsResponse(BaseModel):
    listings: List[Listing]