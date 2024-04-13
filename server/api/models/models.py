from typing import List, Optional
from sqlalchemy import ForeignKey, String, Integer, Enum, Boolean
from sqlalchemy.orm import DeclarativeBase, Mapped, mapped_column, relationship


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
