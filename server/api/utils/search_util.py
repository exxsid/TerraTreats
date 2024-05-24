import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete, or_, and_, case
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Address, Cart, Category, Product, User, Seller
from models.api_base_model import AddToCart
from recommender_system import recommender as rs

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


async def search_product(search_str: str, user_id: int):
    with Session(engine) as session:
        user_loc = (
            session.query(Address.latitude, Address.longitude)
            .select_from(Address)
            .where(Address.user_id == user_id)
            .all()
        )
        recommender_sellers = rs.find_sellers_within_distance(user_loc[0])

        order_dict = {id: i for i, id in enumerate(recommender_sellers)}

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
            .filter(
                and_(
                    or_(
                        Product.product_name.ilike(f"%{search_str}%"),
                        Product.description.ilike(f"%{search_str}%"),
                    ),
                    Seller.id.in_(recommender_sellers),
                )
            )
            .order_by(
                case(*[(Seller.id == id, order) for id, order in order_dict.items()])
            )
        )
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
            "seller": f"{col[9]} {col[10]}",
            "sold": col[11],
            "shipping_fee": col[12],
            "schedule": [],
        }
        res.append(temp)

    return res
