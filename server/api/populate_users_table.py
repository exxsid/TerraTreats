from sqlalchemy.orm import Session
from sqlalchemy import create_engine

from models.models import User, Address, Seller
from models.api_base_model import Login, Signup

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

users = [
    {
        "email": "carlandrew@gmail.com",
        "password": "1234",
        "first_name": "Carl",
        "last_name": "Andrew",
        "phonenumber": "09321025410",
        "is_seller": True,
        "street": "",
        "barangay": "Zaragosa",
        "city": "Bacnotan",
        "province": "La Union",
        "postal_code": "2515"
    },
    {
        "email": "john.doe@gmail.com",
        "password": "qwerty",
        "first_name": "John",
        "last_name": "Doe",
        "phonenumber": "09654712012",
        "is_seller": True,
        "street": "",
        "barangay": "Urbiztondo",
        "city": "San Juan",
        "province": "La Union",
        "postal_code": "2514"
    },
    {
        "email": "leo.cortez@gmail.com",
        "password": "aspirin",
        "first_name": "Leo",
        "last_name": "Cortez",
        "phonenumber": "09673210501",
        "is_seller": False,
        "street": "",
        "barangay": "Ubbog",
        "city": "Bacnotan",
        "province": "La Union",
        "postal_code": "2515"
    },
    {
        "email": "laurasantos5@gmail.com",
        "password": "09876",
        "first_name": "Laura",
        "last_name": "Santos",
        "phonenumber": "09654032105",
        "is_seller": False,
        "street": "",
        "barangay": "Pagdalagan",
        "city": "San Fernando City",
        "province": "La Union",
        "postal_code": "2500"
    },
]

for u in users:
    with Session(engine) as session:
        user = User(email=u['email'], password=u['password'], first_name=u['first_name'], last_name=u['last_name'], phonenumber=u['phonenumber'], is_seller=u['is_seller'] )
        session.add(user)
        session.flush()

        user_id = user.id

        address = Address(user_id=user_id, street=u['street'], barangay=u['barangay'], city=u['city'], province=u['province'], postal_code=u['postal_code'])

        session.add(address)
        session.commit()

print('DDDDDOOONNNNEEEEE')