from sqlalchemy.orm import Session
from sqlalchemy import create_engine

from models.models import User
from models.api_base_model import Login

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)


def get_users():
    with Session(engine) as session:
        result = session.query(User).all()

    return result


async def login_user(credentials: Login):
    with Session(engine) as session:
        result = session.query(User).filter(User.email == credentials.email,
                                            User.password == credentials.password).first()

    return result
