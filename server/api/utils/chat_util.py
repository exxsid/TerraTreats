from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, delete
from sqlalchemy import func
from sqlalchemy.exc import IntegrityError

from models.models import User

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

async def get_user_name(user_id: int) -> str:
    with Session(engine) as session:
        query = select(User.first_name, User.last_name).\
                select_from(User).\
                filter(User.id == user_id)
        result = session.execute(query).all()

        name = f"{result[0][0]} {result[0][1]}"

    return name