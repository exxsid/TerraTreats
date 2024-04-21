import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Cart, Product, User, Seller
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
        query = select(Cart.cart_id, Cart.product_id, Product.product_name, Product.image_url, Product.price, Product.unit, User.first_name, User.last_name).\
            select_from(Product).\
            join(Seller, Product.seller_id == Seller.id).\
            join(User, Seller.user_id == User.id).\
            join(Cart, Cart.product_id == Product.product_id).\
            where(Cart.user_id == user_id)

        result = session.execute(query)

        res = []

        for col in result:
            temp = {
                "cart_id": col[0],
                "product_id": col[1],
                "name": col[2],
                "imgUrl": col[3],
                "price": col[4],
                "unit": col[5],
                "seller": f"{col[6]} {col[7]}",
            }
            res.append(temp)

    return res
