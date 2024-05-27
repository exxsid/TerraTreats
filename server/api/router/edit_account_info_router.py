from fastapi import APIRouter, Response

from models.api_base_model import NewName, NewAddress
from utils import edit_account_info_util as ea

router = APIRouter()


@router.put("/name")
async def edit_name(new_name: NewName):
    result = await ea.edit_name(new_name)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)


@router.put("/password")
async def edit_password(user_id: int, password: str):
    result = await ea.edit_password(user_id, password)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)


@router.put("/phonenumber")
async def edit_phonenumber(user_id: int, phonenumber: str):
    result = await ea.edit_phonenumber(user_id, phonenumber)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)


@router.put("/email")
async def edit_email(user_id: int, email: str):
    result = await ea.edit_email(user_id, email)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=200)


@router.put("/address")
async def edit_address(new_address: NewAddress):
    pass
