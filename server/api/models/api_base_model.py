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
