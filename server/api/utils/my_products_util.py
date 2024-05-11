import random
from sqlalchemy.orm import Session
from sqlalchemy import create_engine, delete, select
from sqlalchemy import update
import base64
import re

from models.models import Category, Seller, User, Product
from models.api_base_model import MyProduct
from utils import cloudinary_service as cs

engine = create_engine('postgresql+psycopg://leo:1234@127.0.0.1:5432/terratreats', echo=True)

async def get_my_products(seller_id: int):
    with Session(engine) as session:
        id = session.execute(
                session.query(Seller.id).select_from(Seller).filter(Seller.user_id == seller_id)
            ).first()
        
        query = select(Product.product_id, Product.product_name, Product.description, Product.price, Product.stock, Product.unit, Product.image_url, Product.rating, Category.category_name, User.first_name, User.last_name, Product.sold, Product.shipping_fee).\
            select_from(Product).\
            join(Category, Product.category_id == Category.category_id).\
            join(Seller, Product.seller_id == Seller.id).\
            join(User, Seller.user_id == User.id).\
            filter(Product.seller_id == id[0])
            
        result = session.execute(query).all()
        
        print(result)
        
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
                "shipping_fee": col[12]
            }
            res.append(temp)
        
    return res

async def update_my_products(updated_product: MyProduct):
    with Session(engine) as session:
        
        # get the id of the updated_product category
        updated_category_id = session.execute(
            session.query(Category.category_id).select_from(Category).\
                filter(Category.category_name == updated_product.category)
        ).first()
        
        print('IIIMMMAAGGEEE', updated_product.image)
        
        if updated_product.image is None \
            or len(updated_product.image) == 0:
            query = update(Product).where(Product.product_id == updated_product.product_id).\
                values(product_name=updated_product.name,
                    description=updated_product.description,
                    price=updated_product.price,
                    stock=updated_product.stock,
                    unit=updated_product.unit,
                    shipping_fee=updated_product.shipping_fee,
                    category_id=updated_category_id[0],
                    )
        else:
            # delete the current image
            old_img_url = session.execute(
                session.query(Product.image_url).select_from(Product).\
                    filter(Product.product_id == updated_product.product_id)
            ).first()
            public_id = extract_cloudinary_id(old_img_url)
            cs.delete_image(public_id)
            
            # upload the new image
            new_image = convert_base64string_to_bytearray(updated_product.image)
            # the folder name is same with th seller id
            folder = public_id.split('/')[0]
            new_img_url = cs.upload_image(new_image, folder)
            
            query = update(Product).where(Product.product_id == updated_product.product_id).\
                values(product_name=updated_product.name,
                    description=updated_product.description,
                    price=updated_product.price,
                    stock=updated_product.stock,
                    unit=updated_product.unit,
                    image_url=new_img_url,
                    shipping_fee=updated_product.shipping_fee,
                    category_id=updated_category_id[0],
                    )
                
        result = session.execute(query)
        count = result.rowcount
        
        if count <= 0:
            return False
        
        session.commit()
        return True
        

def convert_base64string_to_bytearray(base64_string):
    try:
        decoded_bytes = base64.b64decode(base64_string)
    except Exception as e:
        raise ValueError("Invalid Base64 string") from e
    
def extract_cloudinary_id(url):
  """
  Extracts the public ID (2/pxza2ejcyqntjcnoziv4) from a Cloudinary image URL.

  Args:
      url: The Cloudinary image URL.

  Returns:
      The extracted public ID if found, otherwise None.

  Raises:
      ValueError: If the URL format is invalid.
  """
  match = re.search(r"/upload/v\d+/(.*?)\.", url)
  if match:
    return match.group(1)
  else:
    raise ValueError("Invalid Cloudinary image URL format")