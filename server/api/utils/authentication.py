from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select

from models.models import User, Address
from models.api_base_model import Login, Signup

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)


def get_users():
    with Session(engine) as session:
        result = session.query(User).all()

    return result


async def login_user(credentials: Login):
    with Session(engine) as session:
        query = select(User.id, User.email, User.password, User.first_name, User.last_name, User.phonenumber, User.is_seller, Address.street, Address.barangay, Address.city, Address.province, Address.postal_code, User.is_verified).select_from(User).\
            join(Address, User.id == Address.user_id).\
            filter(User.email == credentials.email, User.password == credentials.password)
        result = session.execute(query)

    res = {}
    for col in result:
        res = {
            'id': col[0],
            'email': col[1],
            'password': col[2],
            'first_name': col[3],
            'last_name': col[4],
            'phonenumber': col[5],
            'is_seller': col[6],
            'street': col[7],
            'barangay': col[8],
            'city': col[9],
            'province': col[10],
            'postal_code': col[11],
            'is_verified': col[12],
        }

    return res


async def signup_user(credentials: Signup):
    with Session(engine) as session:
        try:
            user = User(email=credentials.email, password=credentials.password, first_name=credentials.first_name,
                        last_name=credentials.last_name, phonenumber=credentials.phonenumber)

            session.add(user)
            session.flush()

            # get the primary key of the new user
            user_id = user.id

            address = Address(user_id=user_id, street=credentials.street, barangay=credentials.barangay,
                              city=credentials.city, province=credentials.province, postal_code=credentials.postal_code)

            session.add(address)
            session.commit()
            return True
        except Exception as e:
            session.rollback()
            return False
