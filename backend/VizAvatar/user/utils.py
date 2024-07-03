import google.generativeai as genai
from dotenv import load_dotenv
import os
import re
from .models import Food
from .serializers import FoodSerializer
# ===================
load_dotenv()
genai.configure(api_key=os.getenv("GOOGLE_API_KEY"))
model = genai.GenerativeModel('models/gemini-1.5-pro-latest')
# ====================

# Madad krny walay Functions
def extract_nutrients(response):
    nutrient_patterns = {
        'calories': re.compile(r'calories\s*=\s*[^0-9]*(\d+(\.\d+)?|none)[^0-9]*'),
        'protein': re.compile(r'protein\s*=\s*[^0-9]*(\d+(\.\d+)?|none)[^0-9]*'),
        'fat': re.compile(r'fat\s*=\s*[^0-9]*(\d+(\.\d+)?|none)[^0-9]*'),
        'carbohydrates': re.compile(r'carbohydrates\s*=\s*[^0-9]*(\d+(\.\d+)?|none)[^0-9]*'),
        'minerals': re.compile(r'minerals\s*=\s*[^0-9]*(\d+(\.\d+)?|none)[^0-9]*')
    }
    
    nutrients = {
        'calories': 0,
        'protein': 0,
        'fat': 0,
        'carbohydrates': 0,
        'minerals': 0
    }
    
    for nutrient, pattern in nutrient_patterns.items():
        match = pattern.search(response)
        if match:
            value = match.group(1)
            if value == 'none':
                nutrients[nutrient] = 0
            else:
                nutrients[nutrient] = float(value)
    return nutrients


def is_item_food(item_name):
    input_prompt = f"""
    Is {item_name} a food or not 
    give me your response in either Yes or No, do not give me the other text
    """
    
    response = model.generate_content(input_prompt)
    answer = response.text
    answer_in_lowercase = answer.lower()
    
    if "yes" in answer_in_lowercase:
        return True
    else:
        return False


def get_nutrients_per_100grams_or_100ml(food_name, is_drink):
    is_food = is_item_food(food_name)
    # TODO: add a function for validation check if item is liquid or not
    if not is_food:
        return False
    
    unit = "grams"
    if is_drink:
        unit = "milliliters"

    input_prompt = f"""
            You are an expert nutritionist. You need to analyze the food item and calculate its nutritional content per 100 {unit}, including calories, protein, fat, carbohydrates, and minerals.

            Please provide the answer in the following format:

            calories = [number_of_calories]
            protein = [quantity_of_protein]
            fat = [quantity_of_fat]
            carbohydrates = [quantity_of_carbohydrates]
            minerals = [quantity_of_minerals]


            NOTE: For this analysis, use a standard recipe for {food_name}.
            but make sure you give me single number of each nutrient, don't give me the range, you can select the lower value if there is a range
            and if you can't calculate any specific ingredient which i asked just right `none` infront of it rather than writing a description why you can't provide it

            The name of the food is `{food_name}`.
            """
    
    response = model.generate_content(input_prompt)
    answer = response.text
    nutrients = extract_nutrients(answer)
    
    return nutrients
    

def calculate_nutritional_values(food_item, quantity, is_drink_):
    try:
        food = Food.objects.get(name=food_item)
        nutrients = {
            'calories': food.calories,
            'protein': food.protein,
            'fat': food.fat,
            'carbohydrates': food.carbohydrates,
            'minerals': food.minerals,
        }
        is_drink = food.is_drink
    
    except Food.DoesNotExist:
        is_drink = is_drink_
        nutrients_per_100g_or_100ml = get_nutrients_per_100grams_or_100ml(food_item, is_drink)
        if not nutrients_per_100g_or_100ml:
            return "Error: Unable to determine the nutrients for the specified food item."
        
        # Use serializer to save the food data
        food_data = {
            'name': food_item,
            'calories': nutrients_per_100g_or_100ml.get('calories', 0),
            'protein': nutrients_per_100g_or_100ml.get('protein', 0),
            'fat': nutrients_per_100g_or_100ml.get('fat', 0),
            'carbohydrates': nutrients_per_100g_or_100ml.get('carbohydrates', 0),
            'minerals': nutrients_per_100g_or_100ml.get('minerals', 0),
            'is_drink': is_drink
        }

        food_serializer = FoodSerializer(data=food_data)
        if food_serializer.is_valid():
            food_serializer.save()
        else:
            return food_serializer.errors

        nutrients = nutrients_per_100g_or_100ml

    scaled_nutrients = {nutrient: (amount * quantity / 100) for nutrient, amount in nutrients.items()}    

    return scaled_nutrients
