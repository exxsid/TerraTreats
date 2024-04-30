import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Order, OrderItem
from models.api_base_model import PlaceOrder

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

async def post_order(place_order: PlaceOrder):
    try:
        with Session(engine) as session:
            order = Order(user_id=place_order.user_id, order_status=place_order.order_status, shipping_fee=place_order.shipping_fee)

            session.add(order)
            session.flush()

            order_id = order.order_id

            order_item = OrderItem(order_id=order_id, product_id=place_order.product_id, quantity=place_order.quantity, order_size=place_order.order_size)

            session.add(order_item)
            session.commit()
            return True
    except Exception as e:
        print(e)
        session.rollback()
        return False
    