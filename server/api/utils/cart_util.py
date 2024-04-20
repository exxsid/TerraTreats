import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Cart
from models.api_base_model import AddToCart

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)


async def add_to_cart(cart: AddToCart):
    try:

        with Session(engine) as session:
            new_cart = Cart(user_id=cart.user_id, product_id=cart.product_id)

            session.add(new_cart)
            session.flush()

            cart_id = new_cart.cart_id

            session.commit()

        return {"cart_id": cart_id}

    except IntegrityError:
        return None


async def delete_cart(id: uuid.UUID):
    with Session(engine) as session:
        delete_statement = delete(Cart).where(Cart.cart_id == id)

        session.execute(delete_statement)

        session.commit()

    return True


async def get_cart(user_id: int):
    with Session(engine) as session:
        result = session.query(Cart).filter(Cart.user_id == user_id).all()

    return result
