import string
import random
from django.core.mail import send_mail


def generate_confirmation_code(length=6):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

def send_confirmation_email(email, code):
    subject = 'VizAvatar Account Creation Confirmation Email'
    message = f'Hey There Health Buddy! Your VizAvatar new account confirmation code is {code}. It will expire in 1 hour.'
    from_email = 'vizavatar@gmail.com'
    recipient_list = [email]
    send_mail(subject, message, from_email, recipient_list)