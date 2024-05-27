from pydantic import BaseModel


class Login(BaseModel):
    email: str
    password: str


class Signup(BaseModel):
    email: str
    password: str
    first_name: str
    last_name: str
    phonenumber: str
    street: str
    barangay: str
    city: str
    province: str
    postal_code: str


class AddToCart(BaseModel):
    user_id: int
    product_id: int


class PlaceOrder(BaseModel):
    user_id: int
    order_status: str
    shipping_fee: float
    product_id: int
    quantity: int
    order_size: str


class Schedule(BaseModel):
    seller_id: int
    schedule: str


class MyProduct(BaseModel):
    product_id: int
    name: str
    description: str
    price: float
    stock: int
    unit: str
    image: str | None
    category: str
    shipping_fee: float


class NewProduct(BaseModel):
    seller_id: int
    name: str
    description: str
    price: float
    stock: int
    unit: str
    image: str
    category: str
    shipping_fee: float


class Review(BaseModel):
    user_id: int
    product_id: int
    rating: float
    message: str
    order_id: int


class ChatHistory(BaseModel):
    chat_id: str


class SendChat(BaseModel):
    chat_id: str | None
    sender_id: int
    recipient_id: int
    message: str


class NewName(BaseModel):
    user_id: int
    first_name: str
    last_name: str


class NewAddress(BaseModel):
    user_id: int
    street: str | None
    barangay: str
    city: str
    province: str
    zip_code: str
    latitude: float
    longitude: float
