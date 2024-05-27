from fastapi import FastAPI, Response, WebSocket, WebSocketDisconnect
from fastapi.responses import JSONResponse
import json
from fastapi.encoders import jsonable_encoder
import uuid

from utils import parcel_util
from utils import authentication as auth
from utils import home_util, cart_util, search_util
from models.api_base_model import Login, PlaceOrder, Signup, AddToCart
from router import (
    deliver_schedule,
    my_orders,
    my_products_router,
    review_router,
    chat_router,
    edit_account_info_router,
)

app = FastAPI()


@app.get("/")
def get_users():
    return auth.get_users()


@app.post("/login")
async def user_login(credentials: Login):
    result = await auth.login_user(credentials)
    if result is None:
        response = JSONResponse(content={"message": "Wrong email or password"})
        response.status_code = 404
        return response

    response = JSONResponse(content=jsonable_encoder(result))
    response.set_cookie(key="user_id", value=result["id"], secure=True)
    response.status_code = 201
    return response


@app.post("/signup")
async def user_signup(credentials: Signup):
    if credentials is None:
        return Response(status_code=400)

    result = await auth.signup_user(credentials)
    if result is False:
        return Response(status_code=407)

    content = {"message": "yehey"}
    response = JSONResponse(content=content)
    response.status_code = 201
    return response


@app.get("/category")
async def get_categories():
    result = await home_util.get_category()

    if result is None:
        return Response(status_code=404)

    return result


@app.get("/reco-product")
async def get_recommended_products(user_id: int):
    result = await home_util.get_recommended_products(user_id)

    if result is None:
        return Response(status_code=404)

    return result


@app.get("/product")
async def get_product_by_id(id: int):
    result = await home_util.get_product_by_id(id)
    if result is None:
        return Response(status_code=404)

    return result


@app.get("/cat-product")
async def get_product_by_category(category: str, user_id: int):
    result = await home_util.get_product_by_category(category, user_id)

    if result is None:
        return Response(status_code=404)

    return result


@app.get("/featured-product")
async def get_featured_product(zip_code: str):
    result = await home_util.get_featured_product(zip_code)

    if result is None:
        return Response(status_code=404)

    return result


@app.post("/cart")
async def add_to_cart(cart: AddToCart):
    result = await cart_util.add_to_cart(cart)

    if result is None:
        return Response(status_code=400)

    response = JSONResponse(content=jsonable_encoder(result), status_code=201)
    return response


@app.delete("/cart")
async def delete_cart(id: uuid.UUID):
    result = await cart_util.delete_cart(id)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=204)


@app.get("/cart")
async def get_cart(user_id: int):
    result = await cart_util.get_cart(user_id)

    if result is None:
        return Response(status_code=400)

    return result


@app.post("/order")
async def add_order(place_order: PlaceOrder):
    result = await parcel_util.post_order(place_order)

    if result is False:
        return Response(status_code=400)

    return Response(status_code=201)


@app.get("/to-pay")
async def get_to_pay_price(user_id: int):
    result = await parcel_util.get_to_pay_parcel(user_id)

    if result is False:
        return Response(status_code=400)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


@app.get("/to-ship")
async def get_to_ship_parcel(user_id: int):
    result = await parcel_util.get_to_ship_parcel(user_id)

    if result is False:
        return Response(status_code=400)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


@app.get("/to-deliver")
async def get_to_deliver_parcel(user_id: int):
    result = await parcel_util.get_to_deliver_parcel(user_id)

    if result is False:
        return Response(status_code=400)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


@app.get("/to-review")
async def get_to_review_parcel(user_id: int):
    result = await parcel_util.get_to_review_parcel(user_id)

    if result is False:
        return Response(status_code=400)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


@app.get("/search")
async def search_product(search_str: str, user_id: int):
    result = await search_util.search_product(search_str, user_id)

    if result is None:
        return Response(status_code=404)

    return result


# @app.websocket("/ws")
# async def chat(websocket: WebSocket):
#     await manager.connect(websocket)
#     try:
#         while True:
#             data = await websocket.receive_text()
#             await manager.broadcast(data)
#     except WebSocketDisconnect:
#         manager.disconnect(websocket)

# class ConnectionManager:
#     def __init__(self):
#         self.connections = []

#     async def connect(self, websocket):
#         await websocket.accept()
#         self.connections.append(websocket)

#     async def broadcast(self, data):
#         for connection in self.connections:
#             await connection.send_text(data)

#     def disconnect(self, websocket):
#         self.connections.remove(websocket)

# manager = ConnectionManager()

app.include_router(deliver_schedule.router)
app.include_router(my_orders.router)
app.include_router(my_products_router.router)
app.include_router(review_router.router)
app.include_router(chat_router.router)
app.include_router(edit_account_info_router.router)
