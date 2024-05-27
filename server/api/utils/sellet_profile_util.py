import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select

from models.models import Category, Product, Seller, User, Address
from recommender_system import recommender as rs

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


async def get_seller_profile(seller_id: int):
    with Session(engine) as session:
        seller = session.execute(
            select(
                Seller.id,
                User.first_name,
                User.last_name,
                Address.street,
                Address.barangay,
                Address.city,
                Address.province,
                Address.postal_code,
                Seller.description,
                Seller.is_verified,
            )
            .select_from(Seller)
            .join(User, Seller.user_id == User.id)
            .join(Address, User.id == Address.user_id)
            .where(Seller.id == seller_id)
        ).all()

        for col in seller:
            result = {
                "seller_id": col[0],
                "name": f"{col[1]} {col[2]}",
                "address": f"{col[3]}, {col[4]}, {col[5]}, {col[6]}, {col[7]}",
                "description": col[8],
                "is_verified": col[9],
            }

        return result


async def get_seller_products(seller_id: int):
    with Session(engine) as session:
        query = (
            select(
                Product.product_id,
                Product.product_name,
                Product.description,
                Product.price,
                Product.stock,
                Product.unit,
                Product.image_url,
                Product.rating,
                Category.category_name,
                User.first_name,
                User.last_name,
                Product.sold,
                Product.shipping_fee,
            )
            .select_from(Product)
            .join(Category, Product.category_id == Category.category_id)
            .join(Seller, Product.seller_id == Seller.id)
            .join(User, Seller.user_id == User.id)
            .filter(Seller.id == seller_id)
        )

        result = session.execute(query)
    res = []
    for col in result:
        temp = {
            "productId": col[0],
            "name": col[1],
            "description": col[2],
            "price": col[3],
            "stock": col[4],
            "unit": col[5],
            "imgUrl": col[6],
            "rating": col[7],
            "category": col[8],
            "seller": f"{col[9]} {col[10]}",
            "sold": col[11],
            "shipping_fee": col[12],
            "schedule": [],
        }
        res.append(temp)

    return res
