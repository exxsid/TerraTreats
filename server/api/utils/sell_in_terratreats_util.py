import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, update
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Address, Cart, Category, Product, User, Seller
from models.api_base_model import AddToCart
from recommender_system import recommender as rs

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


async def verify_user(user_id: int):
    try:
        with Session(engine) as session:
            update_query = update(User).where(User.id == user_id).values(is_seller=True)

            result = session.execute(update_query)
            affected_row = result.rowcount

            session.commit()
            if affected_row <= 0:
                return False

            return True
    except Exception as e:
        print(e)
        session.rollback()
        return False
