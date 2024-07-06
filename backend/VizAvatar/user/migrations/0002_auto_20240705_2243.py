# Generated by Django 5.0.6 on 2024-07-05 22:43

from django.db import migrations




from django.db import migrations

def create_goals(apps, schema_editor):
    Goal = apps.get_model('user', 'Goal')

    goals = [
        {
            'name': 'Sleep',
            'description': 'User should sleep 7 hours daily',
            'target_amount': 7.0,
            'unit': 'hours'
        },
        {
            'name': 'Walk',
            'description': 'User should walk continuously 25 minutes daily',
            'target_amount': 25.0,
            'unit': 'minutes'
        },
        {
            'name': 'Eat Fruits/Vegetables',
            'description': 'User should eat 500 grams of fruits or vegetables daily',
            'target_amount': 500.0,
            'unit': 'grams'
        },
        {
            'name': 'Walk Steps',
            'description': 'User should walk 10000 steps daily',
            'target_amount': 10000.0,
            'unit': 'steps'
        },
        {
            'name': 'Drink Water',
            'description': 'User should drink 3000ml of water daily',
            'target_amount': 3000.0,
            'unit': 'ml'
        },
    ]

    for goal in goals:
        Goal.objects.create(**goal)

class Migration(migrations.Migration):

    dependencies = [
        ('user', '0001_initial'),
    ]

    operations = [
        migrations.RunPython(create_goals),
    ]