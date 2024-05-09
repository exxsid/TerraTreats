from dotenv import load_dotenv
import os
import smtplib
import random
import string

load_dotenv()

smtp_server = "smtp.gmail.com"
port = 587
sender_email = "terratreats14@gmail.com"
password = os.getenv('EMAIL_PASSWORD')

# store verifications codes and user information
verification_codes = {}

# generate a random verification code
def generate_verification_code():
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(6))

# send the verification code to receiver email
async def send_verification_email(receiver_email):
    subject = "TerraTreats Email Verification"
    body = f"Your verification code is: {generate_verification_code()}"
    
    try:
        # create a smtp connection
        server = smtplib.SMTP(smtp_server, port)
        server.starttls()
        server.login(sender_email, password)
        
        message = f"From: {sender_email}\nTo: {receiver_email}\nSubject: {subject}\n\n{body}"
        
        # send the email
        server.sendmail(sender_email, receiver_email, message)
    except Exception:
        raise Exception("Unable to send verification email")
    finally:
        server.quit()
        
async def verifify_code(user_email, user_input):
    if user_email in verification_codes:
        if user_input == verification_codes[user_email]['code']:
            # Remove the verification code from the dictionary
            del verification_codes[user_email]
            # Perform additional actions upon successful verification
            return True
        else:
            print("Invalid verification code.")
    else:
        print("No verification code found for the provided email.")

    return False