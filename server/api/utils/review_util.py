import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete, update
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError
import uuid

from models.models import Order, Product, Review, User
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
            
            # get the current rating of the product
            current_rating_query = select(Product.rating).\
                select_from(Product).\
                filter(Product.product_id == new_review.product_id)
            current_rating = session.execute(current_rating_query).all()
            
            print("HHHHHHHAAAAA",current_rating)
            
            updated_rating = await calculate_rating(
                new_rating=new_review.rating, 
                current_rating=current_rating[0][0]
                )
            
            # update the row with the updated rating
            update_rating_query = update(Product).\
                where(Product.product_id == new_review.product_id).\
                values(rating=updated_rating)
            update_rating_result = session.execute(update_rating_query)
            
            # update the order status of the row
            orderstatus_query = update(Order).\
                where(Order.order_id == new_review.order_id).\
                values(order_status = 'reviewed')
            orderstatus_result = session.execute(orderstatus_query)
                
            if orderstatus_result.rowcount <= 0 or \
                update_rating_result.rowcount <= 0:
                return False
            
            session.commit()
            
            return True
            
    except Exception as e:
        print("EEEEEEEEEEEEEEE", e)
        session.rollback()
        return False
    
    
async def calculate_rating(new_rating: float, current_rating: float):
    if current_rating == 0:
        return new_rating
    return (current_rating + new_rating) / 2