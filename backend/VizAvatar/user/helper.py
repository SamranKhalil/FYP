import string
import random
from django.core.mail import send_mail

from django.core.mail import EmailMultiAlternatives
from django.template.loader import render_to_string
from django.utils.html import strip_tags


def generate_confirmation_code(length=6):
    characters = string.ascii_letters + string.digits
    return ''.join(random.choice(characters) for _ in range(length))

def send_confirmation_email(email, code):
    context = {
        'confirmation_code': code
    }
    html_content = render_to_string('user/confirmation-email.html', context)
    text_content = strip_tags(html_content)


    subject = 'VizAvatar Account Creation Confirmation Email'
    # message = f'Hey There Health Buddy! Your VizAvatar new account confirmation code is {code}. It will expire in 1 hour.'
    from_email = 'vizavatar@gmail.com'
    recipient_list = [email]

    email = EmailMultiAlternatives( subject, text_content, from_email, recipient_list)
    email.attach_alternative(html_content, "text/html")
    email.send()

    # send_mail(subject, message, from_email, recipient_list)