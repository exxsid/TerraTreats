from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, update
import json

from models.models import User, Address, Seller, Product, Order, OrderItem
from models.api_base_model import Login, Signup

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

async def get_my_orders(seller_id: int):
    with Session(engine) as session:
        id = session.execute(
                session.query(Seller.id).select_from(Seller).filter(Seller.user_id == seller_id)
            ).first()
        query = select(User.first_name, User.last_name, Product.product_name, 
                       Product.price, Product.shipping_fee, Address.street, 
                       Address.barangay, Address.city, Address.province, 
                       Address.postal_code, Order.order_status, OrderItem.order_size, OrderItem.quantity, Product.unit, Order.order_id).\
                       select_from(Order).\
                       join(OrderItem, Order.order_id == OrderItem.order_id).\
                       join(User, Order.user_id == User.id).\
                       join(Product, OrderItem.product_id == Product.product_id).\
                       join(Address, User.id == Address.user_id).\
                       filter(Product.seller_id == id[0]).\
                        order_by(Order.order_status)
                        
        result = session.execute(query).fetchall()

        res = []
        for col in result:
            temp = {
                "name": f"{col[0]} {col[1]}",
                "product": col[2],
                "address": f"{col[5]}, {col[6]}, {col[7]}, {col[8]}, {col[9]}",
                "quantity": f"{col[12]} order of {col[11]} {col[13]}",
                "amount": calculate_amount(col[3], col[12], col[4], col[11]),
                'status': col[10],
                "order_id": col[14]
            }
            res.append(temp)
        return res

        

async def update_order_status(order_id: int, status: str):
    try:
        with Session(engine) as session:
            query = update(Order).where(Order.order_id == order_id).values(order_status=status)
            
            session.execute(query)
            session.commit()
            return 
    except Exception as e:
        session.rollback()
        return False

def calculate_amount(price: float, quantity: int, shipping: float, size: str):
    match (size):
        case "1":
            return price * quantity + shipping
        
        case "3/4":
            return (price * (3/4)) * quantity + shipping
        
        case "1/2":
            return (price * (1/2)) * quantity + shipping
        
        case "1/4":
            return (price * (1/4)) * quantity + shipping