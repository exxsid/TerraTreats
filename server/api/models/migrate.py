from sqlalchemy import create_engine
from sqlalchemy.orm import Session

from models.models import User, Address, Base

engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                       echo=True)

# print('Establishing Connection')
# conn = engine.connect()


# Base.metadata.create_all(engine)

# engine.dispose()


with Session(engine) as session:
    u1 = Address(
        barangay='Zaragosa',
        city='Bacnotan',
        province='La Union',
        postal_code='2515',
        user_id='1'
    )

    session.add(u1)

    session.commit()
