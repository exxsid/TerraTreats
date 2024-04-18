from sqlalchemy.orm import Session
from sqlalchemy import create_engine

from models.models import Product
from models.api_base_model import Login, Signup

from dotenv import load_dotenv, dotenv_values
import os
import cloudinary
from cloudinary.uploader import upload

engine = engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats',
                                echo=True)

load_dotenv()
cloudinary.config(
    cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"),
    api_key=os.getenv('CLOUDINARY_API_KEY'),
    api_secret=os.getenv('CLOUDINARY_API_SECRET')
)


def upload_image(image_path, folder_name):
    with open(image_path, "rb") as image_file:
        byte_array = bytearray(image_file.read())

    response = upload(byte_array, folder=folder_name)

    if response is None:
        return None

    return response['secure_url']


url1 = upload_image("C:/Users/Asus/Pictures/terratreats/1.jpg", 1)
prod1 = Product(product_name="amapalaya", description="Sariwang ampalaya galing laki sa bakuran.",
                price=20, stock=10, unit="kg", image_url=url1, category_id=2, seller_id=1)

url2 = upload_image("C:/Users/Asus/Pictures/terratreats/2.jpg", 1)
prod2 = Product(product_name="Saluyot", description="Hindi naisprayan na saluyot. All natural.",
                price=10, stock=15, unit="pc", image_url=url2, category_id=2, seller_id=1)

url3 = upload_image("C:/Users/Asus/Pictures/terratreats/3.jpg", 1)
prod3 = Product(product_name="Upo", description="Masarap na upo, mapapawow ka sa sarap.",
                price=25, stock=7, unit="kg", image_url=url3, category_id=2, seller_id=1)

url4 = upload_image("C:/Users/Asus/Pictures/terratreats/4.jpg", 1)
prod4 = Product(product_name="Kalabasa", description="Kalabasa pampalinaw ng mata, kaya bili na mga suki presyong divesoria. ",
                price=30, stock=9, unit="kg", image_url=url4, category_id=2, seller_id=1)

url5 = upload_image("C:/Users/Asus/Pictures/terratreats/5.jpg", 1)
prod5 = Product(product_name="Sitaw | String beans", description="Sitaw na mahaba, para buhay mo'y humaba. Hindi naispriyan at masarap pa.",
                price=25, stock=13, unit="pc", image_url=url5, category_id=2, seller_id=1)

url6 = upload_image("C:/Users/Asus/Pictures/terratreats/6.jpg", 2)
prod6 = Product(product_name="Pork Belly", description="Masarap, fresh, walang halong gamot at manipis ang taba",
                price=120, stock=10, unit="kg", image_url=url6, category_id=3, seller_id=2)

url7 = upload_image("C:/Users/Asus/Pictures/terratreats/7.jpg", 2)
prod7 = Product(product_name="Chicken Drumstick", description="Mapapatambol ka sa sarap. Fresh pa mga suki",
                price=100, stock=11, unit="kg", image_url=url7, category_id=3, seller_id=2)

url8 = upload_image("C:/Users/Asus/Pictures/terratreats/8.jpg", 2)
prod8 = Product(product_name="Beef Tapa", description="Siguradong mabibighani ka sa sarap ng aming Beef Tapa! Ang aming espesyal na lutuin, tampok sa bawat kagat, tiyak na pampasigla ng iyong araw!",
                price=200, stock=8, unit="kg", image_url=url8, category_id=3, seller_id=2)

url9 = upload_image("C:/Users/Asus/Pictures/terratreats/9.jpg", 2)
prod9 = Product(product_name="Chicken Breast", description="Lasang sarap na hindi mo makakalimutan! Subukan ang aming Juicy Chicken Breast, siguradong magpapatikim sa'yo ng kakaibang saya at sarap ng bawat kagat",
                price=120, stock=17, unit="kg", image_url=url9, category_id=3, seller_id=2)

url10 = upload_image("C:/Users/Asus/Pictures/terratreats/10.png", 2)
prod10 = Product(product_name="Chicken Skin", description="Tikman ang kakaibang sarap ng aming Crispy Chicken Skin! Isang paglantakan na puno ng linamnam at katakam-takam na saya sa bawat subo",
                 price=100, stock=12, unit="kg", image_url=url10, category_id=3, seller_id=2)

with Session(engine) as session:
    session.add(prod1)
    session.add(prod2)
    session.add(prod3)
    session.add(prod4)
    session.add(prod5)
    session.add(prod6)
    session.add(prod7)
    session.add(prod8)
    session.add(prod9)
    session.add(prod10)

    session.commit()
