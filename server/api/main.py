from fastapi import FastAPI, Response
from fastapi.responses import JSONResponse
import json

from utils import authentication as auth
from models.api_base_model import Login, Signup

app = FastAPI()


@app.get("/")
def get_users():
    return auth.get_users()


@app.post('/login')
async def user_login(credentials: Login):
    result = await auth.login_user(credentials)
    if result is None:
        response = JSONResponse(content={"message": "Wrong email or password"})
        response.status_code = 404
        return response

    content = {"email": result.email, "password": result.password}
    response = JSONResponse(content=content)
    response.set_cookie(key="user_id", value=result.id, secure=True)
    response.status_code = 201
    return response


@app.post("/signup")
async def user_signup(credentials: Signup):
    if credentials is None:
        return Response(status_code=406)

    result = await auth.signup_user(credentials)
    if result is False:
        return Response(status_code=406)

    content = {"message": "yehey"}
    response = JSONResponse(content=content)
    response.status_code = 201
    return response
