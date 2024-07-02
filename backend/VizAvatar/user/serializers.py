from rest_framework import serializers
from .models import User, NutritionalIntake, Food

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'age', 'gender', 'height', 'weight', 'email', 'password']
        extra_kwargs = {'password': {'write_only': True}}

    def create(self, validated_data):
        user = User(**validated_data)
        user.save()
        return user

class NutritionalIntakeSerializer(serializers.ModelSerializer):
    class Meta:
        model = NutritionalIntake
        fields = ['id', 'user', 'timestamp', 'food_name', 'protein', 'fat', 'carbohydrates', 'minerals', 'calories']

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
        fields = ['name', 'calories', 'protein', 'fat', 'carbohydrates', 'minerals']

class DateRangeSerializer(serializers.Serializer):
    start_date = serializers.DateField()
    end_date = serializers.DateField()