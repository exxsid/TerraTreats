import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Cart, Category, Product, User, Seller
from models.api_base_model import AddToCart

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

async def search_product(search_str: str):
    with Session(engine) as session:
        query = select(Product.product_id, Product.product_name, Product.description, Product.price, Product.stock, Product.unit, Product.image_url, Product.rating, Category.category_name, User.first_name, User.last_name).\
            select_from(Product).\
            join(Category, Product.category_id == Category.category_id).\
            join(Seller, Product.seller_id == Seller.id).\
            join(User, Seller.user_id == User.id).\
            filter(Product.product_name.ilike(f"%{search_str}%"))
        print("QQUUUUEERRYYY", query)
        result = session.execute(query).fetchall()

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
            "seller": f"{col[9]} {col[10]}"
        }
        res.append(temp)

    return res