from pydantic import BaseModel, Field, ConfigDict
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

    updated_at: str
    weighted_score: List[float] = Field(alias="weighted_score")
    model_config = ConfigDict(validate_by_name=True)


class CreateListingRequest(BaseModel):
    price: float
    date_listed: str
    image_url: Optional[str] = None

    longitude: float
    latitude: float
    address: str

    square_footage: Optional[int] = None
    bathroom_num: Optional[int] = Field(None, alias="bathroom_num")
    bedrooms_num: Optional[int] = Field(None, alias="bedrooms_num")
    backyard: Optional[bool] = None
    garage: Optional[bool] = None
    description: Optional[str] = None

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
    description: Optional[str] = None
    
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