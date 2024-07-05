from rest_framework import serializers
from .models import User, NutritionalIntake, Food, Goal, UserDailyGoalStatus, DailyHealthRecord

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['username', 'age', 'gender', 'height', 'weight', 'email', 'password', 'prevalentStroke', 'prevalentHypertension', 'diabetes', 'dob', 'BPmeds']
        {
            'password': {'write_only': True},
            'username': {'required': True},
            'age': {'required': True},
            'gender': {'required': True},
            'height': {'required': True},
            'weight': {'required': True},
            'email': {'required': True},

            'prevalentStroke': {'required': False},
            'prevalentHypertension': {'required': False},
            'diabetes': {'required': False},
            'dob': {'required': False},
            'BPmeds': {'required': False}
        }

    def create(self, validated_data):
        user = User(
            email=validated_data['email'],
            username=validated_data['username'],
            age=validated_data['age'],
            gender=validated_data['gender'],
            height=validated_data['height'],
            weight=validated_data['weight'],

            prevalentStroke=validated_data.get('prevalentStroke', False),
            prevalentHypertension=validated_data.get('prevalentHypertension', False),
            diabetes=validated_data.get('diabetes', False),
            dob=validated_data.get('dob', None),
            BPmeds=validated_data.get('BPmeds', False),
        )
        user.set_password(validated_data['password'])
        user.save()
        return user

class NutritionalIntakeSerializer(serializers.ModelSerializer):
    class Meta:
        model = NutritionalIntake
        fields = ['id', 'user', 'timestamp', 'food_name', 'protein', 'fat', 'carbohydrates', 'minerals', 'calories', 'quantity' ]

class FoodSerializer(serializers.ModelSerializer):
    class Meta:
        model = Food
        fields = ['name', 'calories', 'protein', 'fat', 'carbohydrates', 'minerals', 'is_drink']

class DateRangeSerializer(serializers.Serializer):
    start_date = serializers.DateField()
    end_date = serializers.DateField()


class GoalSerializer(serializers.ModelSerializer):
    class Meta:
        model = Goal
        fields = ['id', 'name', 'description', 'target_amount', 'unit']

class UserDailyGoalStatusSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserDailyGoalStatus
        fields = ['id', 'user', 'goal', 'date', 'amount_achieved']

class DailyHealthRecordSerializer(serializers.ModelSerializer):
    class Meta:
        model = DailyHealthRecord
        fields = ['user', 'date', 'sex', 'age', 'currentSmoker', 'cigsPerDay', 'BPmeds', 'prevalentStroke', 'prevalentHyp', 'diabetes', 'totChol', 'sysBP', 'diaBP', 'BMI', 'heartRate', 'glucose']