from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import make_password, check_password
from .models import User, NutritionalIntake, Goal, UserDailyGoalStatus, DailyHealthRecord,EmailConfirmation
from .serializers import UserSerializer, NutritionalIntakeSerializer, DateRangeSerializer, UserDailyGoalStatusSerializer, DailyHealthRecordSerializer
from django.utils import timezone
from .utils import calculate_nutritional_values, is_Fruit_or_Vegetable
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication
from .helper import send_confirmation_email, generate_confirmation_code
from django.shortcuts import get_object_or_404
from datetime import date
from decimal import Decimal
import pandas as pd


import joblib
import numpy as np
from django.utils import timezone
from datetime import timedelta
from .models import DailyHealthRecord



import logging

logger = logging.getLogger(__name__)

class UserSignup(APIView):
    def post(self, request, *args, **kwargs):
        data = request.data.copy()
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            user = serializer.save()
            email_confirmation = EmailConfirmation.objects.create(user=user)
            send_confirmation_email(user.email, email_confirmation.confirmation_code)
            return Response({'message': 'Confirmation code sent to your email'}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ConfirmEmail(APIView):
    def post(self, request, *args, **kwargs):
        confirmation_code = request.data.get('confirmation_code')
        try:
            email_confirmation = EmailConfirmation.objects.get(confirmation_code=confirmation_code)

            if email_confirmation.is_confirmed:
                return Response({'error': 'Confirmation code already used'}, status=status.HTTP_400_BAD_REQUEST)
        
            if email_confirmation.is_expired():
                return Response({'error': 'Confirmation code expired'}, status=status.HTTP_400_BAD_REQUEST)

            email_confirmation.is_confirmed = True
            email_confirmation.save()

            user = email_confirmation.user
            user.is_active = True
            user.save()
        
            token = Token.objects.create(user=user)
            gender = (user.gender).lower()
            return Response({'message': 'Email confirmed successfully', 'token': token.key, 'gender': gender}, status=status.HTTP_200_OK)
        
        except EmailConfirmation.DoesNotExist:
            return Response({'error': 'Invalid confirmation code'}, status=status.HTTP_400_BAD_REQUEST)
        
        except Exception as e:
            return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
class ResendConfirmationCode(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        user = get_object_or_404(User, email=email)
        
        if user.email_confirmation.is_confirmed:
            return Response({'error': 'Email already confirmed'}, status=status.HTTP_400_BAD_REQUEST)

        email_confirmation = user.email_confirmation
        email_confirmation.confirmation_code = generate_confirmation_code()
        email_confirmation.created_at = timezone.now()
        email_confirmation.save()
        send_confirmation_email(user.email, email_confirmation.confirmation_code)
        return Response({'message': 'New confirmation code sent to your email'}, status=status.HTTP_200_OK)

class UserLogin(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')
        print("email",email)
        print("password",password)
        try:
            user = User.objects.get(email=email)
            if check_password(password, user.password):
                if not user.is_active:
                    return Response({'error': 'Email not confirmed. Please confirm your email before logging in.', 'isActive': user.is_active}, status=status.HTTP_200_OK)
                token, created = Token.objects.get_or_create(user=user)
                return Response({'message': 'Login successful!', 'token': token.key, 'isActive': user.is_active}, status=status.HTTP_200_OK)
            logger.warning(f'Password mismatch for user: {user.email}')
            return Response({'error': 'Invalid email or password '}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({'error': 'User Doest not Exists'}, status=status.HTTP_400_BAD_REQUEST)

class AddNutritionalIntakeView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        food_item = request.data.get('food_item')
        quantity = request.data.get('quantity')
        is_drink = request.data.get('is_drink')
        user = request.user
        print(food_item)
        print(quantity)
        print(is_drink)

        print("food_item", food_item)
        print("quantity", quantity)
        print("is_drink", is_drink)

        if food_item is None or quantity is None or is_drink is None:
            return Response({'error': 'Food item and quantity and category are required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            quantity = float(quantity)
            nutritional_values = calculate_nutritional_values(food_item, quantity, is_drink)
            if isinstance(nutritional_values, str):
                return Response({'error': nutritional_values}, status=status.HTTP_400_BAD_REQUEST)
        except ValueError as e:
            return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
        
        units = "grams"
        if is_drink:
            units = "milliliters"
        quantity_of_user_food_intake = str(quantity) + units

        data = {
            'user': user.id,
            'timestamp': timezone.now(),
            'food_name': food_item,
            'protein': nutritional_values.get('protein', 0),
            'fat': nutritional_values.get('fat', 0),
            'carbohydrates': nutritional_values.get('carbohydrates', 0),
            'minerals': nutritional_values.get('minerals', 0),
            'calories': nutritional_values.get('calories', 0),
            'quantity': quantity_of_user_food_intake
        }

        serializer = NutritionalIntakeSerializer(data=data)

        if serializer.is_valid():
            serializer.save()

            is_Fruit = is_Fruit_or_Vegetable(food_item)
            if is_Fruit:
                goal_id = 3
                date = timezone.now().date()
                try:
                    goal_status = UserDailyGoalStatus.objects.get(user=user, goal_id=goal_id, date=date)
                    goal_status.amount_achieved += Decimal(quantity)
                    goal_status.save()
                except UserDailyGoalStatus.DoesNotExist:
                    quantity = Decimal(quantity)
                    UserDailyGoalStatus.objects.create(user=user, goal_id=goal_id, date=date, amount_achieved=quantity)

            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class NutritionalSummaryView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        serializer = DateRangeSerializer(data=request.data)
        if serializer.is_valid():
            start_date = serializer.validated_data['start_date']
            end_date = serializer.validated_data['end_date']
            user = request.user

            intakes = NutritionalIntake.objects.filter(user=user, timestamp__date__range=[start_date, end_date])

            if not intakes.exists():
                return Response({'message': 'No data found for the given date range'}, status=status.HTTP_404_NOT_FOUND)

            total_calories = intakes.aggregate(total=Sum('calories'))['total']
            total_protein = intakes.aggregate(total=Sum('protein'))['total']
            total_fat = intakes.aggregate(total=Sum('fat'))['total']
            total_carbohydrates = intakes.aggregate(total=Sum('carbohydrates'))['total']
            total_minerals = intakes.aggregate(total=Sum('minerals'))['total']

            # Calculate the percentages
            total_nutrients = total_protein + total_fat + total_carbohydrates + total_minerals
            if total_nutrients > 0:
                protein_percentage = (total_protein / total_nutrients) * 100
                fat_percentage = (total_fat / total_nutrients) * 100
                carbohydrates_percentage = (total_carbohydrates / total_nutrients) * 100
                minerals_percentage = (total_minerals / total_nutrients) * 100
            else:
                protein_percentage = fat_percentage = carbohydrates_percentage = minerals_percentage = 0
            
            food_list = intakes.values('food_name', 'calories', 'quantity', 'timestamp').order_by('-timestamp')
            
            result = {
                'nutrients': {
                    'total_calories': total_calories,
                    'protein_percentage': protein_percentage,
                    'fat_percentage': fat_percentage,
                    'carbohydrates_percentage': carbohydrates_percentage,
                    'minerals_percentage': minerals_percentage,
                },
                'foodList': list(food_list)
            }

            return Response(result, status=status.HTTP_200_OK)
        else:
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        


class UpdateDailyGoalStatusView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        goal_id = request.data.get('goal_id')
        amount_achieved = request.data.get('amount_achieved')
        date = request.data.get('date', timezone.now().date())

        if not goal_id or not amount_achieved:
            return Response({'error': 'Goal ID and amount achieved are required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            goal = Goal.objects.get(id=goal_id)
        except Goal.DoesNotExist:
            return Response({'error': 'Goal not found'}, status=status.HTTP_404_NOT_FOUND)
        
        try:
            record = UserDailyGoalStatus.objects.get(user=user, goal=goal, date=date)
            record.amount_achieved += Decimal(amount_achieved)
            record.save() 
        except:
            amount_achieved = Decimal(amount_achieved)
            record = UserDailyGoalStatus.objects.create(user=user, goal=goal, date=date, amount_achieved=amount_achieved)

        serializer = UserDailyGoalStatusSerializer(record)
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    
    def get(self, request, *args, **kwargs):
        user = request.user
        date = timezone.now().date()
        
        records = UserDailyGoalStatus.objects.filter(user=user, date=date)
        if not records.exists():
            return Response({'message': 'No data found for the current date'}, status=status.HTTP_404_NOT_FOUND)

        serializer = UserDailyGoalStatusSerializer(records, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

class DailyGoalSummaryView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user
        date = request.query_params.get('date', timezone.now().date())  # Default to today if not provided
        statuses = UserDailyGoalStatus.objects.filter(user=user, date=date)

        if not statuses.exists():
            return Response({'message': 'No data found for the given date'}, status=status.HTTP_404_NOT_FOUND)

        serializer = UserDailyGoalStatusSerializer(statuses, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    

# TODO: test this either this view is working fine in all use cases or not
class DailyHealthRecordView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def calculate_age(self, dob):
        today = date.today()
        return today.year - dob.year - ((today.month, today.day) < (dob.month, dob.day))

    def post(self, request, *args, **kwargs):
        
        user = request.user
        
        age = self.calculate_age(user.dob)
        
        # Prepare data for the serializer
        data = request.data.copy()
        data['user'] = user.id
        data['age'] = age
        data['sex'] = 1 if user.gender.lower() == 'male' else 0
        data['prevalentStroke'] = user.prevalentStroke
        data['prevalentHyp'] = user.prevalentHypertension
        data['diabetes'] = user.diabetes
        data['currentSmoker'] = user.currentSmoker

        serializer = DailyHealthRecordSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, *args, **kwargs):
        user = request.user
        date = request.query_params.get('date')
        if date:
            records = DailyHealthRecord.objects.filter(user=user, date=date)
        else:
            records = DailyHealthRecord.objects.filter(user=user)
        serializer = DailyHealthRecordSerializer(records, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)
    
class ValidateTokenView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def get(self, request, *args, **kwargs):
        user = request.user


        # Load the saved logistic regression model
        model_path = '/home/okami/Desktop/FYP/FYP/backend/model.pkl'
        trained_model = joblib.load(model_path)
        
        feature_order_path = '/home/okami/Desktop/FYP/FYP/backend/feature_order.pkl'
        feature_order = joblib.load(feature_order_path)

        scaler_path = '/home/okami/Desktop/FYP/FYP/backend/scaler.pkl'
        mms = joblib.load(scaler_path)

        # Fetch the last 30 days of data from DailyHealthRecord
        end_date = timezone.now().date()
        start_date = end_date - timedelta(days=30)
        records = DailyHealthRecord.objects.filter(user=user, date__range=[start_date, end_date])

        if not records.exists():
            isHealthy = user.isHealthy
            gender = (user.gender).lower()
            return Response({'message': 'Token is valid', 'isHealthy': isHealthy, 'gender': gender}, status=status.HTTP_200_OK)

        # Aggregate the data by taking the average of each column
        aggregated_data = records.aggregate(
            avg_age=Sum('age') / len(records),
            avg_sex=Sum('sex') / len(records),
            avg_currentSmoker=Sum('currentSmoker') / len(records),
            avg_cigsPerDay=Sum('cigsPerDay') / len(records),
            avg_BPmeds=Sum('BPmeds') / len(records),
            avg_prevalentStroke=Sum('prevalentStroke') / len(records),
            avg_prevalentHyp=Sum('prevalentHyp') / len(records),
            avg_diabetes=Sum('diabetes') / len(records),
            avg_totChol=Sum('totChol') / len(records),
            avg_sysBP=Sum('sysBP') / len(records),
            avg_diaBP=Sum('diaBP') / len(records),
            avg_BMI=Sum('BMI') / len(records),
            avg_heartRate=Sum('heartRate') / len(records),
            avg_glucose=Sum('glucose') / len(records)
        )
        
        # Prepare data for prediction
        input_data = {
            'age': user.age,
            'sex': 1 if user.gender.lower() == 'male' else 0,
            'is_smoking': user.currentSmoker,
            'prevalentStroke': user.prevalentStroke,
            'prevalentHyp': user.prevalentHypertension,
            'diabetes': user.diabetes,
            'cigsPerDay': aggregated_data['avg_cigsPerDay'],
            'BPMeds': aggregated_data['avg_BPmeds'],
            'totChol': aggregated_data['avg_totChol'],
            'sysBP': aggregated_data['avg_sysBP'],
            'diaBP': aggregated_data['avg_diaBP'],
            'BMI': aggregated_data['avg_BMI'],
            'heartRate': aggregated_data['avg_heartRate'],
            'glucose': aggregated_data['avg_glucose']
        }

        # Convert to DataFrame for pre-processing
        user_data = pd.DataFrame([input_data])

        # Add interaction feature
        user_data['age_cigsPerDay'] = user_data['age'] * user_data['cigsPerDay']

        # Ensure the correct order of features
        user_data = user_data[feature_order]

        # Log transformation
        user_data = np.log(user_data + 1)

        # Scaling
        user_data_scaled = mms.transform(user_data)

        # Make prediction
        prediction = trained_model.predict(user_data_scaled)
        prediction_proba = trained_model.predict_proba(user_data_scaled)

        prediction = int(prediction)
        
        isHealthy = True
        if(prediction == 0):
            isHealthy = False
        user.isHealthy = isHealthy
        gender = (user.gender).lower()
        return Response({{'message': 'Token is valid', 'isHealthy': isHealthy, 'gender': gender}}, status=status.HTTP_200_OK)
        

