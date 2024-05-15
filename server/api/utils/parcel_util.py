import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Category, Order, OrderItem, Product, Seller, User
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


async def get_to_pay_parcel(user_id: int):
    with Session(engine) as session:        
        query = select (Product.product_id, Product.product_name, 
                        Product.image_url, Product.price, Product.unit, 
                        Product.rating, User.first_name, User.last_name, 
                        Order.shipping_fee, OrderItem.quantity, 
                        OrderItem.order_size, Order.order_id).\
                        select_from(Order).\
                        join(OrderItem, Order.order_id == OrderItem.order_id).\
                        join(Product, 
                             OrderItem.product_id == Product.product_id).\
                        join(Seller, Product.seller_id == Seller.id).\
                        join(User, Seller.user_id == User.id).\
                        filter(Order.order_status == 'pending',
                               Order.user_id == user_id)

        result = session.execute(query)
    res = []
    for col in result:
        temp = {
            'product_id': col[0],
            'product_name': col[1],
            'img_url': col[2],
            'price': col[3],
            'unit': col[4],
            'rating': col[5],
            'seller': f"{col[6]} {col[7]}",
            'order_size': col[10],
            'total_price': calculate_total_price(
                col[3], col[9], col[8], col[10]
            ),
            'order_id': col[11],
        }

        res.append(temp)


    return res

async def get_to_ship_parcel(user_id: int):
    with Session(engine) as session:        
        query = select (Product.product_id, Product.product_name, 
                        Product.image_url, Product.price, Product.unit, 
                        Product.rating, User.first_name, User.last_name, 
                        Order.shipping_fee, OrderItem.quantity, 
                        OrderItem.order_size, Order.order_id).\
                        select_from(Order).\
                        join(OrderItem, Order.order_id == OrderItem.order_id).\
                        join(Product, 
                             OrderItem.product_id == Product.product_id).\
                        join(Seller, Product.seller_id == Seller.id).\
                        join(User, Seller.user_id == User.id).\
                        filter(Order.order_status == 'confirmed',
                               Order.user_id == user_id)

        result = session.execute(query)
    res = []
    for col in result:
        temp = {
            'product_id': col[0],
            'product_name': col[1],
            'img_url': col[2],
            'price': col[3],
            'unit': col[4],
            'rating': col[5],
            'seller': f"{col[6]} {col[7]}",
            'order_size': col[10],
            'total_price': calculate_total_price(
                col[3], col[9], col[8], col[10]
            ),
            'order_id': col[11],
        }

        res.append(temp)


    return res

async def get_to_deliver_parcel(user_id: int):
    with Session(engine) as session:        
        query = select (Product.product_id, Product.product_name, 
                        Product.image_url, Product.price, Product.unit, 
                        Product.rating, User.first_name, User.last_name, 
                        Order.shipping_fee, OrderItem.quantity, 
                        OrderItem.order_size, Order.order_id).\
                        select_from(Order).\
                        join(OrderItem, Order.order_id == OrderItem.order_id).\
                        join(Product, 
                             OrderItem.product_id == Product.product_id).\
                        join(Seller, Product.seller_id == Seller.id).\
                        join(User, Seller.user_id == User.id).\
                        filter(Order.order_status == 'out_for_delivery',
                               Order.user_id == user_id)

        result = session.execute(query)
    res = []
    for col in result:
        temp = {
            'product_id': col[0],
            'product_name': col[1],
            'img_url': col[2],
            'price': col[3],
            'unit': col[4],
            'rating': col[5],
            'seller': f"{col[6]} {col[7]}",
            'order_size': col[10],
            'total_price': calculate_total_price(
                col[3], col[9], col[8], col[10]
            ),
            'order_id': col[11],
        }

        res.append(temp)


    return res

async def get_to_review_parcel(user_id: int):
    with Session(engine) as session:        
        query = select (Product.product_id, Product.product_name, 
                        Product.image_url, Product.price, Product.unit, 
                        Product.rating, User.first_name, User.last_name, 
                        Order.shipping_fee, OrderItem.quantity, 
                        OrderItem.order_size, Order.order_id).\
                        select_from(Order).\
                        join(OrderItem, Order.order_id == OrderItem.order_id).\
                        join(Product, 
                             OrderItem.product_id == Product.product_id).\
                        join(Seller, Product.seller_id == Seller.id).\
                        join(User, Seller.user_id == User.id).\
                        filter(Order.order_status == 'delivered',
                               Order.user_id == user_id)

        result = session.execute(query)
    res = []
    for col in result:
        temp = {
            'product_id': col[0],
            'product_name': col[1],
            'img_url': col[2],
            'price': col[3],
            'unit': col[4],
            'rating': col[5],
            'seller': f"{col[6]} {col[7]}",
            'order_size': col[10],
            'total_price': calculate_total_price(
                col[3], col[9], col[8], col[10]
            ),
            "order_id": col[11]
        }

        res.append(temp)


    return res

def calculate_total_price(price, quantity, shipping, size):
    match (size):
        case "1":
            return price * quantity + shipping
        
        case "3/4":
            return (price * (3/4)) * quantity + shipping
        
        case "1/2":
            return (price * (1/2)) * quantity + shipping
        
        case "1/4":
            return (price * (1/4)) * quantity + shipping