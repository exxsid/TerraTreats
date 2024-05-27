from fastapi import APIRouter
from fastapi.responses import Response

from utils import sell_in_terratreats_util as situ

router = APIRouter()


@router.post("/verify-seller-application")
async def verify_seller_application(user_id: int):
    result = await situ.verify_user(user_id)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)
