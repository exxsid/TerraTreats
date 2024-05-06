import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, delete, select
from sqlalchemy import func

from models.models import DeliverySchedule, Seller, User
from models.api_base_model import Schedule

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

async def add_deliver_schedule(sched: Schedule):
    try:
        with Session(engine) as session:
            schedule = DeliverySchedule(seller_id=sched.seller_id, schedule=sched.schedule)

            result = session.add(schedule)
            session.commit()
            return True
    except Exception as e:
        session.rollback()
        return False
    
async def get_delivery_schedules(seller_id: int):
    try:
        with Session(engine) as session:
            id = session.execute(
                session.query(Seller.id).select_from(Seller).filter(Seller.user_id == seller_id)
            ).first()
            query = session.query(DeliverySchedule.deliver_id, DeliverySchedule.schedule).\
                        select_from(DeliverySchedule).\
                        filter(DeliverySchedule.seller_id == id[0])
            result = session.execute(query).all()

            res = []
            for col in result:
                temp = {
                    "deliver_id": col[0],
                    "schedule": col[1]
                }
                res.append(temp)

            return res
    except TypeError as e:
        return []
    

async def delete_delivery_schedule(deliver_id: int):
    try:

        with Session(engine) as session:
            delete_statement = delete(DeliverySchedule).where(DeliverySchedule.deliver_id == deliver_id)

            session.execute(delete_statement)

            session.commit()

        return True
    except Exception as e:
        session.rollback()
        return False