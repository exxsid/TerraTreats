from typing import List, Optional
from sqlalchemy import ForeignKey, String, Integer, Enum, Boolean, Float, DateTime
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship
from sqlalchemy.sql import func
from sqlalchemy.dialects.postgresql import UUID


class Base(DeclarativeBase):
    pass


class User(Base):
    __tablename__ = 'users'

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    email: Mapped[str] = mapped_column(String(50), unique=True, nullable=False)
    password: Mapped[str] = mapped_column(String(12), nullable=False)
    first_name: Mapped[str] = mapped_column(String(50), nullable=False)
    last_name: Mapped[str] = mapped_column(String(50), nullable=False)
    phonenumber: Mapped[str] = mapped_column(String(50), nullable=False)
    is_seller: Mapped[bool] = mapped_column(Boolean(), default=False)

    def __repr__(self) -> str:
        return f"User(id={self.id}, email={self.email}, password={self.password}, first_name={self.first_name}, last_name={self.last_name}, phonenumber={self.phonenumber}, is_seller={self.is_seller})"


class Address(Base):
    __tablename__ = 'addresses'

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    street: Mapped[str] = mapped_column(String(100), nullable=True)
    barangay: Mapped[str] = mapped_column(String(100), nullable=False)
    city: Mapped[str] = mapped_column(String(100), nullable=False)
    province: Mapped[str] = mapped_column(String(100), nullable=False)
    postal_code: Mapped[str] = mapped_column(String(100), nullable=False)
    user_id: Mapped[int] = mapped_column(
        ForeignKey('users.id'), nullable=False)

    def __repr__(self) -> str:
        return f"Address(id={self.id}, stree={self.street}, barangay={self.barangay}, city={self.city}, province={self.province}, postal_code={self.postal_code}, user_id={self.user_id})"


class Seller(Base):
    __tablename__ = 'sellers'

    id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    description: Mapped[str] = mapped_column(String())
    is_verified: Mapped[bool] = mapped_column(Boolean(), default=False)
    verification_url: Mapped[str] = mapped_column(String(), nullable=True)
    user_id: Mapped[int] = mapped_column(
        ForeignKey('users.id'), nullable=False)

    def __repr__(self) -> str:
        return f"Seller(id={self.id}, description={self.description}, is_verified={self.is_verified}, verification_url={self.verification_url}, user_id={self.user_id})"


class Category(Base):
    __tablename__ = 'categories'

    category_id: Mapped[int] = mapped_column(
        primary_key=True, autoincrement=True)
    category_name: Mapped[str] = mapped_column(String(100), nullable=False)

    def __repr__(self) -> str:
        return f"Category(category_id={self.category_id}, category_name={self.category_name})"


class Product(Base):
    __tablename__ = 'products'

    product_id: Mapped[int] = mapped_column(
        primary_key=True, autoincrement=True)
    product_name: Mapped[int] = mapped_column(String())
    description: Mapped[str] = mapped_column(String())
    price: Mapped[float] = mapped_column(Float())
    stock: Mapped[int] = mapped_column(Integer())
    unit: Mapped[str] = mapped_column(String())
    image_url: Mapped[str] = mapped_column(String())
    rating: Mapped[float] = mapped_column(Float(), default=0, nullable=True)
    category_id: Mapped[int] = mapped_column(
        ForeignKey('categories.category_id'))
    seller_id: Mapped[int] = mapped_column(ForeignKey(
        'sellers.id', ondelete='CASCADE', onupdate='CASCADE'))

    def __repr__(self) -> str:
        return f"Product(product_id={self.product_id}, product_name={self.product_name}, description={self.description}, price={self.price}, stock={self.stock}, image_url={self.image_url}, category_id={self.category_id}, user_id={self.user_id})"


class Order(Base):
    __tablename__ = 'orders'

    order_id: Mapped[int] = mapped_column(primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey('users.id'))
    # TODO order status enum
    shipping_fee: Mapped[float] = mapped_column(Float())

    def __repr__(self) -> str:
        return f"Order(order_id={self.order_id}, user_id={self.user_id}, shipping_fee={self.shipping_fee})"


class OrderItem(Base):
    __tablename__ = 'order_items'

    order_item_id: Mapped[int] = mapped_column(
        primary_key=True, autoincrement=True)
    order_id: Mapped[int] = mapped_column(ForeignKey("orders.order_id"))
    prodcut_id: Mapped[int] = mapped_column(ForeignKey("products.product_id"))
    quantity: Mapped[int] = mapped_column(Integer())

    def __repr__(self) -> str:
        return f"OrderItem(order_item_id={self.order_item_id}, order_id={self.order_id}, product_id={self.product_id}, quantity={self.quantity})"


class Review(Base):
    __tablename__ = 'reviews'

    review_id: Mapped[int] = mapped_column(
        primary_key=True, autoincrement=True)
    user_id: Mapped[int] = mapped_column(ForeignKey("users.id"))
    product_id: Mapped[int] = mapped_column(ForeignKey("products.product_id"))
    rating: Mapped[int] = mapped_column(Integer())
    title: Mapped[str] = mapped_column(String(), nullable=True)
    message: Mapped[str] = mapped_column(String())
    created_at: Mapped[DateTime] = mapped_column(
        DateTime(), server_default=func.now())
    update_at: Mapped[DateTime] = mapped_column(
        DateTime(), server_onupdate=func.now())

    def __repr__(self) -> str:
        return f"Review(review_id={self.review_id}, user_id={self.user_id}, product_id={self.product_id}, rating={self.rating}, title={self.title}, message={self.message}, created_at={self.created_at}, update_at={self.update_at})"


class Cart(Base):
    __tablename__ = 'carts'

    cart_id: Mapped[UUID] = mapped_column(UUID(as_uuid=True), primary_key=True)
    user_id: Mapped[int] = mapped_column(ForeignKey(
        "users.id", ondelete='CASCADE', onupdate="CASCADE"))
    product_id: Mapped[int] = mapped_column(ForeignKey(
        "products.product_id", ondelete='CASCADE', onupdate="CASCADE"))

    def __repr__(self) -> str:
        return f"Cart(card_id={self.cart_id}, user_id={self.user_id}, product_id={self.product_id})"
