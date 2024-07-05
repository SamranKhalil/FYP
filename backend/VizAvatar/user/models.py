from django.db import models
from django.conf import settings
from django.contrib.auth.models import AbstractBaseUser, BaseUserManager, PermissionsMixin
from .helper import generate_confirmation_code
from django.utils import timezone
from datetime import timedelta

class CustomUserManager(BaseUserManager):
    def create_user(self, email, password=None, **extra_fields):
        if not email:
            raise ValueError('The Email field must be set')
        email = self.normalize_email(email)
        user = self.model(email=email, **extra_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self, email, password=None, **extra_fields):
        extra_fields.setdefault('is_staff', True)
        extra_fields.setdefault('is_superuser', True)
        return self.create_user(email, password, **extra_fields)


class User(AbstractBaseUser, PermissionsMixin):
    username = models.CharField(max_length=50, unique=True, blank=False, null=False)
    age = models.IntegerField(blank=False, null=False)
    gender = models.CharField(max_length=10, blank=False, null=False)
    height = models.DecimalField(max_digits=5, decimal_places=2, blank=False, null=False)
    weight = models.DecimalField(max_digits=5, decimal_places=2, blank=False, null=False)
    email = models.EmailField(unique=True, blank=False, null=False)
    password = models.CharField(max_length=255, blank=False, null=False)
    is_active = models.BooleanField(default=False)
    is_staff = models.BooleanField(default=False)
    date_joined = models.DateTimeField(auto_now_add=True)

    prevalentStroke = models.BooleanField(default=False)
    prevalentHypertension = models.BooleanField(default=False)
    diabetes = models.BooleanField(default=False)
    dob = models.DateField(blank=True, null=True)

    USERNAME_FIELD = 'email'
    REQUIRED_FIELDS = ['username', 'age', 'gender', 'height', 'weight']

    objects = CustomUserManager()

    class Meta:
        db_table = 'users'


class NutritionalIntake(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    food_name = models.CharField(max_length=255)
    protein = models.DecimalField(max_digits=10, decimal_places=2)
    fat = models.DecimalField(max_digits=10, decimal_places=2)
    carbohydrates = models.DecimalField(max_digits=10, decimal_places=2)
    minerals = models.DecimalField(max_digits=10, decimal_places=2)
    calories = models.DecimalField(max_digits=10, decimal_places=2)
    quantity = models.CharField(max_length=255, default='100 grams')

    def __str__(self):
        return f"{self.user.username} - {self.timestamp}"


class Food(models.Model):
    name = models.CharField(max_length=255, unique=True)
    calories = models.DecimalField(max_digits=10, decimal_places=2)
    protein = models.DecimalField(max_digits=10, decimal_places=2)
    fat = models.DecimalField(max_digits=10, decimal_places=2)
    carbohydrates = models.DecimalField(max_digits=10, decimal_places=2)
    minerals = models.DecimalField(max_digits=10, decimal_places=2)
    is_drink = models.BooleanField(default=False)

    def __str__(self):
        return self.name
    

class Goal(models.Model):
    name = models.CharField(max_length=255)
    description = models.TextField(blank=True, null=True)
    target_amount = models.DecimalField(max_digits=10, decimal_places=2)
    unit = models.CharField(max_length=50)

    def __str__(self):
        return self.name

class UserDailyGoalStatus(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    goal = models.ForeignKey(Goal, on_delete=models.CASCADE)
    date = models.DateField()
    amount_achieved = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        unique_together = ('user', 'goal', 'date')

    def __str__(self):
        return f"{self.user.username} - {self.goal.name} - {self.date}"

class DailyHealthRecord(models.Model):
    SEX_CHOICES = [
        (0, 'Female'),
        (1, 'Male'),
    ]

    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    date = models.DateField()
    sex = models.IntegerField(choices=SEX_CHOICES)
    age = models.IntegerField()
    currentSmoker = models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])
    cigsPerDay = models.IntegerField(null=True, blank=True)
    BPmeds = models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])
    prevalentStroke = models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])
    prevalentHyp = models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])
    diabetes = models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])
    totChol = models.DecimalField(max_digits=5, decimal_places=2)
    sysBP = models.DecimalField(max_digits=5, decimal_places=2)
    diaBP = models.DecimalField(max_digits=5, decimal_places=2)
    BMI = models.DecimalField(max_digits=5, decimal_places=2)
    heartRate = models.IntegerField()
    glucose = models.DecimalField(max_digits=5, decimal_places=2)

    class Meta:
        unique_together = ('user', 'date')
        db_table = 'daily_health_records'

    def __str__(self):
        return f"{self.user.username} - {self.date}"

class EmailConfirmation(models.Model):
    user = models.OneToOneField(settings.AUTH_USER_MODEL, on_delete=models.CASCADE, related_name='email_confirmation')
    confirmation_code = models.CharField(max_length=6)
    created_at = models.DateTimeField(auto_now_add=True)
    is_confirmed = models.BooleanField(default=False)

    def save(self, *args, **kwargs):
        if not self.confirmation_code:
            self.confirmation_code = generate_confirmation_code()
        super().save(*args, **kwargs)

    def is_expired(self):
        return timezone.now() > self.created_at + timezone.timedelta(hours=1)
    
    def __str__(self):
        return f'{self.user.email} - {self.confirmation_code}'