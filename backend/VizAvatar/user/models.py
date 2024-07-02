from django.db import models
from django.conf import settings

class User(models.Model):
    id = models.AutoField(primary_key=True)
    username = models.CharField(max_length=50, unique=True)
    age = models.IntegerField()
    gender = models.CharField(max_length=10)
    height = models.DecimalField(max_digits=5, decimal_places=2)
    weight = models.DecimalField(max_digits=5, decimal_places=2)
    email = models.EmailField(unique=True)
    password = models.CharField(max_length=255)

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

    def __str__(self):
        return f"{self.user.username} - {self.timestamp}"


class Food(models.Model):
    name = models.CharField(max_length=255, unique=True)
    calories = models.DecimalField(max_digits=10, decimal_places=2)
    protein = models.DecimalField(max_digits=10, decimal_places=2)
    fat = models.DecimalField(max_digits=10, decimal_places=2)
    carbohydrates = models.DecimalField(max_digits=10, decimal_places=2)
    minerals = models.DecimalField(max_digits=10, decimal_places=2)

    def __str__(self):
        return self.name