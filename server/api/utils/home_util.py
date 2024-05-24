import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, select
from sqlalchemy import func

from models.models import Category, Product, Seller, User, DeliverySchedule, Address

engine = engine = create_engine(
    "postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats", echo=True
)


async def get_category():
    with Session(engine) as session:
        result = session.query(Category).all()

    return result


async def get_recommended_products():
    with Session(engine) as session:
        query = (
            select(
                Product.product_id,
                Product.product_name,
                Product.description,
                Product.price,
                Product.stock,
                Product.unit,
                Product.image_url,
                Product.rating,
                Category.category_name,
                User.first_name,
                User.last_name,
                Product.sold,
                Product.shipping_fee,
            )
            .select_from(Product)
            .join(Category, Product.category_id == Category.category_id)
            .join(Seller, Product.seller_id == Seller.id)
            .join(User, Seller.user_id == User.id)
        )

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
            "seller": f"{col[9]} {col[10]}",
            "sold": col[11],
            "shipping_fee": col[12],
            "schedule": [],
        }
        res.append(temp)

    return res


async def get_product_by_id(id: int):
    with Session(engine) as session:
        query = (
            select(
                Product.product_id,
                Product.product_name,
                Product.description,
                Product.price,
                Product.stock,
                Product.unit,
                Product.image_url,
                Product.rating,
                Category.category_name,
                User.first_name,
                User.last_name,
                Product.sold,
                Product.shipping_fee,
                Seller.id,
            )
            .select_from(Product)
            .join(Category, Product.category_id == Category.category_id)
            .join(Seller, Product.seller_id == Seller.id)
            .join(User, Seller.user_id == User.id)
            .filter(Product.product_id == id)
        )

        result = session.execute(query).all()

        query_schedule = (
            select(DeliverySchedule.schedule)
            .select_from(DeliverySchedule)
            .filter(DeliverySchedule.seller_id == result[0][13])
        )

        result_schedule = session.execute(query_schedule)
    res = {}
    for col in result:
        res = {
            "productId": col[0],
            "name": col[1],
            "description": col[2],
            "price": col[3],
            "stock": col[4],
            "unit": col[5],
            "imgUrl": col[6],
            "rating": col[7],
            "category": col[8],
            "seller": f"{col[9]} {col[10]}",
            "sold": col[11],
            "shipping_fee": col[12],
            "schedule": [sched[0] for sched in result_schedule],
        }

    return res


async def get_featured_product(zip_code: str):
    with Session(engine) as session:

        sellers = (
            session.query(Seller.id)
            .select_from(Seller)
            .join(Address, Seller.user_id == Address.user_id)
            .where(Address.postal_code == zip_code)
            .all()
        )
        num_sellers = len(sellers)

        if num_sellers <= 0:
            query = (
                select(
                    Product.product_id,
                    Product.product_name,
                    Product.description,
                    Product.price,
                    Product.stock,
                    Product.unit,
                    Product.image_url,
                    Product.rating,
                    Category.category_name,
                    User.first_name,
                    User.last_name,
                    Product.sold,
                )
                .select_from(Product)
                .join(Category, Product.category_id == Category.category_id)
                .join(Seller, Product.seller_id == Seller.id)
                .join(User, Seller.user_id == User.id)
                .limit(1)
            )
        else:
            rand_index = random.randrange(0, num_sellers)

            selected_seller = sellers[rand_index][0]

            query = (
                select(
                    Product.product_id,
                    Product.product_name,
                    Product.description,
                    Product.price,
                    Product.stock,
                    Product.unit,
                    Product.image_url,
                    Product.rating,
                    Category.category_name,
                    User.first_name,
                    User.last_name,
                    Product.sold,
                )
                .select_from(Product)
                .join(Category, Product.category_id == Category.category_id)
                .join(Seller, Product.seller_id == Seller.id)
                .join(User, Seller.user_id == User.id)
                .where(Seller.id == selected_seller)
                .limit(1)
            )

        col = session.execute(query).fetchone()

        res = {
            "productId": col[0],
            "name": col[1],
            "description": col[2],
            "price": col[3],
            "stock": col[4],
            "unit": col[5],
            "imgUrl": col[6],
            "rating": col[7],
            "category": col[8],
            "seller": f"{col[9]} {col[10]}",
            "sold": col[11],
        }

    return res


async def get_product_by_category(category: str):
    with Session(engine) as session:
        query = (
            select(
                Product.product_id,
                Product.product_name,
                Product.description,
                Product.price,
                Product.stock,
                Product.unit,
                Product.image_url,
                Product.rating,
                Category.category_name,
                User.first_name,
                User.last_name,
                Product.sold,
                Product.shipping_fee,
            )
            .select_from(Product)
            .join(Category, Product.category_id == Category.category_id)
            .join(Seller, Product.seller_id == Seller.id)
            .join(User, Seller.user_id == User.id)
            .filter(Category.category_name.ilike(category))
        )

        result = session.execute(query).fetchall()
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
            "seller": f"{col[9]} {col[10]}",
            "sold": col[11],
            "shipping_fee": col[12],
            "schedule": [],
        }

        res.append(temp)

    return res
