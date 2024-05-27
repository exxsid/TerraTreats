import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select

from models.models import Category, Product, Seller, User
from recommender_system import recommender as rs

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


async def get_seller_profile(seller_id: int):
    with Session(engine) as session:
        seller = session.query(Seller).where(Seller.id == seller_id).first()

        return seller


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
