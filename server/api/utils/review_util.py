import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete, update
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Order, Review, User
from models.api_base_model import Review as rev

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

async def get_reviews(product_id: int):
    with Session(engine) as session:
        query = select(
                Review.review_id, User.first_name, User.last_name,
                Review.rating, Review.message,
            ).\
            select_from(Review).\
            join(User, Review.user_id == User.id).\
            order_by(Review.update_at).\
            filter(Review.product_id == product_id)
            
        result = session.execute(query).all()
        
        res = []
        for col in result:
            temp = {
                'review_id': col[0],
                'user_name': f"{col[1]} {col[2]}",
                'rating': col[3],
                'message': col[4],
            }
            res.append(temp)
            
    return res

async def add_review(new_review: rev):
    try:
        with Session(engine) as session:
            review = Review(
                user_id=new_review.user_id, 
                product_id=new_review.product_id,
                rating=new_review.rating,
                message=new_review.message,
                update_at=func.now()
                )
            
            session.add(review)
            session.flush()
            
            # TODO updating order status 
            query = update(Order).\
                where(Order.order_id == new_review.order_id).\
                values(order_status = 'reviewed')
                
            result = session.execute(query)
                
            if result.rowcount <= 0:
                return False
            
            session.commit()
            
            return True
            
    except Exception as e:
        print("EEEEEEEEEEEEEEE", e)
        session.rollback()
        return False