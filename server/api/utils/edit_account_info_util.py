from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select, update

from models.models import User, Address, Seller
from models.api_base_model import NewName

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


async def edit_name(new_name: NewName):
    try:
        with Session(engine) as session:
            update_query = (
                update(User)
                .where(User.id == new_name.user_id)
                .values(
                    first_name=new_name.first_name,
                    last_name=new_name.last_name,
                )
            )

            result = session.execute(update_query)
            affected_row = result.rowcount

            session.commit()
            if affected_row <= 0:
                return False

            return True
    except Exception as e:
        print(e)
        session.rollback()
        return False


async def edit_password(user_id: int, password: str):
    try:
        with Session(engine) as session:
            update_query = (
                update(User).where(User.id == user_id).values(password=passwords)
            )

            result = session.execute(update_query)
            affected_row = result.rowcount

            session.commit()
            if affected_row <= 0:
                return False

            return True
    except Exception:
        session.rollback()
        return False


async def edit_phonenumber(user_id: int, phonenumber: str):
    try:
        with Session(engine) as session:
            update_query = (
                update(User).where(User.id == user_id).values(phonenumber=phonenumber)
            )

            result = session.execute(update_query)
            affected_row = result.rowcount

            session.commit()
            if affected_row <= 0:
                return False

            return True
    except Exception:
        session.rollback()
        return False


async def edit_email(user_id: int, email: str):
    try:
        with Session(engine) as session:
            update_query = update(User).where(User.id == user_id).values(email=email)

            result = session.execute(update_query)
            affected_row = result.rowcount

            session.commit()
            if affected_row <= 0:
                return False

            return True
    except Exception:
        session.rollback()
        return False
