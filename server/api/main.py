from fastapi import FastAPI, Response
from fastapi.responses import JSONResponse
import json

from utils import authentication as auth
from models.api_base_model import Login

app = FastAPI()


@app.get("/")
def get_users():
    return auth.get_users()


@app.post('/login')
async def user_login(credentials: Login):
    result = await auth.login_user(credentials)
    if result is None:
        return None

    content = {"email": result.email, "password": result.password}
    response = JSONResponse(content=content)
    response.set_cookie(key="user_id", value=result.id, secure=True)
    return response
