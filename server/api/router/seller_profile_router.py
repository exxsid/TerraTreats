from fastapi import APIRouter
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from utils import sellet_profile_util as spu

router = APIRouter(prefix="/seller-profile")


@router.get("")
async def get_seller_profile(seller_id: int):
    result = await spu.get_seller_profile(seller_id)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


@router.get("/products")
async def get_seller_products(seller_id: int):
    result = await spu.get_seller_products(seller_id)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)
