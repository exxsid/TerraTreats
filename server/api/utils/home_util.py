from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select

from models.models import Category, Product, Seller, User

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)


async def get_category():
    with Session(engine) as session:
        result = session.query(Category).all()

    return result


async def get_recommended_products():
    with Session(engine) as session:
        query = select(Product.product_id, Product.product_name, Product.description, Product.price, Product.stock, Product.unit, Product.image_url, Product.rating, Category.category_name, User.first_name, User.last_name).\
            select_from(Product).\
            join(Category, Product.category_id == Category.category_id).\
            join(Seller, Product.seller_id == Seller.id).\
            join(User, Seller.user_id == User.id)

        result = session.execute(query)
    res = []
    for col in result:
        temp = {
            "productId": col[0],
            "name": col[1],
            "description": col[2],
            "price": col[3],
            "stock": col[4],
            "unit": col[5],
            "imgUrl": col[6],
            "rating": col[7],
            "category": col[8],
            "seller": f"{col[9]} {col[10]}"
        }
        res.append(temp)

    return res
