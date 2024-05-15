from fastapi import APIRouter
from fastapi.responses import JSONResponse, Response
from fastapi.encoders import jsonable_encoder

from models.api_base_model import Review
from utils import review_util as ru

router = APIRouter()

@router.get("/reviews")
async def get_reviews(product_id: int):
    result = await ru.get_reviews(product_id)
    
    return JSONResponse(content=jsonable_encoder(result), status_code=200)

@router.post("/reviews")
async def add_review(review: Review):
    result = await ru.add_review(review)
    
    if result is False:
        return Response(status_code=400)
    
    return Response(status_code=201)