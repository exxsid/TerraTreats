from sqlalchemy.orm import Session
from sqlalchemy import create_engine

from models.models import Category
from models.api_base_model import Login, Signup

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

cat1 = Category(category_name="Fruits")
cat2 = Category(category_name="Vegetables")
cat3 = Category(category_name="Meat")
cat4 = Category(category_name="Grains")
cat5 = Category(category_name="Dairy")

with Session(engine) as session:
    session.add(cat1)
    session.add(cat2)
    session.add(cat3)
    session.add(cat4)
    session.add(cat5)

    session.commit()
