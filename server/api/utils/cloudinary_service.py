from dotenv import load_dotenv, dotenv_values
import os
import cloudinary
from cloudinary.uploader import upload

load_dotenv()

cloudinary.config(
    cloud_name=os.getenv("CLOUDINARY_CLOUD_NAME"),
    api_key=os.getenv('CLOUDINARY_API_KEY'),
    api_secret=os.getenv('CLOUDINARY_API_SECRET')
)


def upload_image(byte_array, folder_name):
    """
    byte_array -> coverted image file to byte array
    folder_name -> the id of the user/seller

    return the url of the uploaded image
    """
    response = upload(byte_array, folder=folder_name)

    if response is None:
        return None

    return response['secure_url']
