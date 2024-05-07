from fastapi import APIRouter, Response
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from utils import my_order_util as mou

router = APIRouter()

@router.get("/my-orders")
async def get_my_orders(seller_id: int):
    result = await mou.get_my_orders(seller_id)

    if (result == None):
        return Response(status_code=400)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)

@router.post("/my-orders")
async def update_order_status(order_id: int, new_status: str):
    result = await mou.update_order_status(order_id, new_status)
    
    if result is False:
        return Response(status_code=400)
    
    return Response(status_code=201)