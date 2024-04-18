from sqlalchemy.orm import Session
from sqlalchemy import create_engine

from models.models import User, Address, Seller
from models.api_base_model import Login, Signup

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

seller1 = Seller(description="Selling the freshiest vegetable in town.",
                 is_verified=True, user_id=9)
seller2 = Seller(description="Looking for high-quality meat delivered fresh to your door? We offer a wide selection of pork, beef, and chicken, perfect for grilling, roasting, or your favorite recipe.  Choose from convenient cuts or specialty items, all sourced from reputable farms.", is_verified=True, user_id=2)

with Session(engine) as session:
    session.add(seller1)
    session.add(seller2)
    session.commit()
