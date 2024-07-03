from django.shortcuts import render
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth.hashers import make_password, check_password
from .models import User, NutritionalIntake, Goal, UserDailyGoalStatus, DailyHealthRecord
from .serializers import UserSerializer, NutritionalIntakeSerializer, DateRangeSerializer, UserDailyGoalStatusSerializer, DailyHealthRecordSerializer
from django.utils import timezone
from .utils import calculate_nutritional_values
from rest_framework.permissions import IsAuthenticated
from django.db.models import Sum
from rest_framework.authtoken.models import Token
from rest_framework.authentication import TokenAuthentication

class UserSignup(APIView):
    def post(self, request, *args, **kwargs):
        data = request.data.copy()
        data['password'] = make_password(data['password'])
        serializer = UserSerializer(data=data)
        if serializer.is_valid():
            user = serializer.save()
            token, created = Token.objects.create(user=user)
            response_data = serializer.data
            response_data['token'] = token.key
            return Response(response_data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class UserLogin(APIView):
    def post(self, request, *args, **kwargs):
        email = request.data.get('email')
        password = request.data.get('password')
        try:
            user = User.objects.get(email=email)
            if check_password(password, user.password):
                token, created = Token.objects.get_or_create(user=user)
                return Response({'message': 'Login successful!', 'token': token.key}, status=status.HTTP_200_OK)
            return Response({'error': 'Invalid email or password '}, status=status.HTTP_400_BAD_REQUEST)
        except User.DoesNotExist:
            return Response({'error': 'Invalid Email or password'}, status=status.HTTP_400_BAD_REQUEST)

class AddNutritionalIntakeView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        food_item = request.data.get('food_item')
        quantity = request.data.get('quantity')
        is_drink = request.data.get('is_drink')
        user = request.user

        if not food_item or not quantity or not is_drink:
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
            return Response(serializer.data, status=status.HTTP_201_CREATED)
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
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        user = request.user
        goal_id = request.data.get('goal_id')
        amount_achieved = request.data.get('amount_achieved')
        date = request.data.get('date', timezone.now().date())  # Default to today if not provided

        if not goal_id or not amount_achieved:
            return Response({'error': 'Goal ID and amount achieved are required'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            goal = Goal.objects.get(id=goal_id)
        except Goal.DoesNotExist:
            return Response({'error': 'Goal not found'}, status=status.HTTP_404_NOT_FOUND)

        record, created = UserDailyGoalStatus.objects.update_or_create(
            user=user,
            goal=goal,
            date=date,
            defaults={'amount_achieved': amount_achieved}
        )

        serializer = UserDailyGoalStatusSerializer(record)
        return Response(serializer.data, status=status.HTTP_201_CREATED)

class DailyGoalSummaryView(APIView):
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

    def post(self, request, *args, **kwargs):
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