from fastapi import APIRouter, Response
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from utils import my_products_util as mpu
from models.api_base_model import MyProduct, NewProduct

router = APIRouter()


@router.get("/my-products")
async def get_my_products(seller_id: int):
    result = await mpu.get_my_products(seller_id)

    if result is None:
        return Response(status_code=400)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


@router.put("/my-products")
async def update_my_products(updated_product: MyProduct):
    result = await mpu.update_my_products(updated_product)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)


@router.post("/my-products")
async def add_my_product(new_product: NewProduct):
    result = await mpu.add_product(new_product)


@router.delete("/my-products")
async def delete_product(product_id: int):
    result = await mpu.delete_product(product_id)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)
