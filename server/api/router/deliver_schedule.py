from fastapi import APIRouter, Response
from fastapi.responses import JSONResponse
from fastapi.encoders import jsonable_encoder

from utils import delivery_schedule_util as dsu
from models.api_base_model import Schedule

router = APIRouter()

@router.post("/delivery-schedule")
async def add_delivert_schedule(sched: Schedule):
    result = await dsu.add_deliver_schedule(sched)

    if result is False:
        return Response(status_code=400)
    
    return Response(status_code=201)

@router.get("/delivery-schedule")
async def get_delivery_schedules(seller_id: int):
    result = await dsu.get_delivery_schedules(seller_id)

    if result is None:
        return Response(status_code=404)
    
    return JSONResponse(content=jsonable_encoder(result), status_code=200)