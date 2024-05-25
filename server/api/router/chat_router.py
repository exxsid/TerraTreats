from datetime import datetime
from typing import Dict, List
from bson.objectid import ObjectId
from fastapi import APIRouter, Response, WebSocket, WebSocketDisconnect
import asyncio
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from fastapi.encoders import jsonable_encoder

from models.api_base_model import ChatHistory, SendChat
from utils import chat_util as cu

router = APIRouter()


class ConnectionManager:
    def __init__(self):
        self.connections: Dict[int, WebSocket] = {}
        self.client = AsyncIOMotorClient("mongodb://leo:1234@localhost:27017")
        self.db = self.client.test
        self.chat = self.db.chat

    async def connect(self, websocket: WebSocket, id: int):
        await websocket.accept()
        self.connections[id] = websocket

    async def handle_connections(self, websocket: WebSocket, id: int):
        try:
            while True:
                data = await websocket.receive_text()
        except WebSocketDisconnect:
            manager.disconnect(websocket, id)

    async def broadcast(self, data, sender: WebSocket):
        for conn in self.connections:
            if conn is not sender:
                await conn.send_text(data)

    async def private_message(self, chat: SendChat):
        # when the sender is not connected to the socket
        if not self.connections.get(chat.sender_id):
            raise Exception("No connected")

        # when the recipient is offline
        if not self.connections.get(chat.recipient_id):
            await self.connections.get(chat.sender_id).send_json(
                jsonable_encoder(
                    {
                        "sender_id": chat.sender_id,
                        "recipient_id": chat.recipient_id,
                        "message": chat.message,
                        "timestamp": datetime.now(),
                    }
                )
            )
            await self.store_message(chat)
            return

        await self.connections.get(chat.recipient_id).send_json(
            jsonable_encoder(
                {
                    "sender_id": chat.sender_id,
                    "recipient_id": chat.recipient_id,
                    "message": chat.message,
                    "timestamp": datetime.now(),
                }
            )
        )
        await self.connections.get(chat.sender_id).send_json(
            jsonable_encoder(
                {
                    "sender_id": chat.sender_id,
                    "recipient_id": chat.recipient_id,
                    "message": chat.message,
                    "timestamp": datetime.now(),
                }
            )
        )
        # await self.connections.get(chat.recipient_id).send_text(chat.message)
        await self.store_message(chat)

    async def store_message(self, chat: SendChat):
        if chat.chat_id == None:
            chat_doc = None
        else:
            chat_doc = await self.db.chat.find_one({"_id": ObjectId(chat.chat_id)})

        # when the chat document is already exist
        if chat_doc:
            chat_doc["messages"].append(
                {
                    "sender_id": chat.sender_id,
                    "recipient_id": chat.recipient_id,
                    "message": chat.message,
                    "timestamp": datetime.now(),
                }
            )

            await self.chat.update_one(
                {"_id": chat_doc["_id"]}, {"$set": {"messages": chat_doc["messages"]}}
            )
        else:
            chat_doc = {
                "participants": [chat.sender_id, chat.recipient_id],
                "messages": [
                    {
                        "sender_id": chat.sender_id,
                        "recipient_id": chat.recipient_id,
                        "message": chat.message,
                        "timestamp": datetime.now(),
                    }
                ],
            }
            await self.chat.insert_one(chat_doc)

    async def chat_messages(self, user_id: int):
        # to be more efficient, retrieving of chats include only
        # _id and participants
        filter = {"_id": 1, "participants": 1}
        chat_doc = await self.chat.find({"participants": user_id}, filter).to_list(
            length=None
        )

        if not chat_doc:
            return []

        result = []
        # get the recipient name
        for chat in chat_doc:
            recipient_id = (
                chat.get("participants")[0]
                if chat.get("participants")[0] != user_id
                else chat.get("participants")[1]
            )

            name = await cu.get_user_name(recipient_id)

            temp = {
                "id": str(chat.get("_id")),
                "recipient": name,
                "recipeint_id": recipient_id,
            }
            result.append(temp)
        return result

    async def chat_history(self, chat_id: str):
        chat_doc = await self.chat.find_one({"_id": ObjectId(chat_id)})

        if not chat_doc:
            return []

        sorted_messages = sorted(
            chat_doc["messages"], key=lambda msg: msg["timestamp"], reverse=True
        )

        return [
            {
                "sender_id": msg["sender_id"],
                "message": msg["message"],
                "timestamp": msg["timestamp"],
            }
            for msg in sorted_messages
        ]

    def disconnect(self, websocket, id):
        self.connections.pop(id)


manager = ConnectionManager()


@router.websocket("/connect")
async def connect(websocket: WebSocket, id: int):
    await manager.connect(websocket, id)
    await manager.handle_connections(websocket, id)


# let the user to send chat to a specific user
@router.post("/chat/send")
async def private_chat(chat: SendChat):
    try:
        await manager.private_message(chat)

        return JSONResponse(
            content=jsonable_encoder({"message": chat.message}), status_code=200
        )
    except Exception as e:
        print(e)
        return Response(status_code=400)


# get the chat history for private message
@router.get("/chat/history")
async def get_chat_history(chat_id: str):
    if len(chat_id) == 0:
        return JSONResponse(content=jsonable_encoder([]), status_code=200)

    result = await manager.chat_history(chat_id)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)


# get the chat that the user is in
@router.get("/chat/messages")
async def get_chats(id: int):
    result = await manager.chat_messages(id)

    return JSONResponse(content=jsonable_encoder(result), status_code=200)
