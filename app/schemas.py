from pydantic import BaseModel, Field
from typing import Optional, List

class DatabaseListing(BaseModel):
    id: str

    price: float
    date_listed: str
    image_url: Optional[str] = None

    # Location fields
    longitude: float
    latitude: float
    address: str

    # Amenities (optional)
    square_footage: Optional[int] = None
    bathroom_num: Optional[int] = Field(None, alias="bathroom_num")
    bedrooms_num: Optional[int] = Field(None, alias="bedrooms_num")
    backyard: Optional[bool] = None
    garage: Optional[bool] = None

    weighted_score: float
    updated_at: str

class Listing(BaseModel):
    id: str

    price: float
    date_listed: str
    image_url: Optional[str] = None

    # Location fields
    longitude: float
    latitude: float
    address: str

    # Amenities (optional)
    square_footage: Optional[int] = None
    bathroom_num: Optional[int] = Field(None, alias="bathroom_num")
    bedrooms_num: Optional[int] = Field(None, alias="bedrooms_num")
    backyard: Optional[bool] = None
    garage: Optional[bool] = None

class SearchRequest(BaseModel):
    # Location fields
    address: str
    longitude: float
    latitude: float

    # Amenities (optional)
    square_footage: Optional[int] = None
    bathroom_num: Optional[int] = Field(None, alias="bathroom_num")
    bedrooms_num: Optional[int] = Field(None, alias="bedrooms_num")
    backyard: Optional[bool] = None
    garage: Optional[bool] = None

    # Price range (optional)
    min_price: Optional[float] = Field(None, alias="min_price")
    max_price: Optional[float] = Field(None, alias="max_price")

class ListingsResponse(BaseModel):
    listings: List[Listing]