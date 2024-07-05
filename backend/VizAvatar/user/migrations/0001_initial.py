# Generated by Django 5.0.6 on 2024-07-05 22:41

import django.db.models.deletion
from django.conf import settings
from django.db import migrations, models


class Migration(migrations.Migration):

    initial = True

    dependencies = [
        ('auth', '0012_alter_user_first_name_max_length'),
    ]

    operations = [
        migrations.CreateModel(
            name='Food',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255, unique=True)),
                ('calories', models.DecimalField(decimal_places=2, max_digits=10)),
                ('protein', models.DecimalField(decimal_places=2, max_digits=10)),
                ('fat', models.DecimalField(decimal_places=2, max_digits=10)),
                ('carbohydrates', models.DecimalField(decimal_places=2, max_digits=10)),
                ('minerals', models.DecimalField(decimal_places=2, max_digits=10)),
                ('is_drink', models.BooleanField(default=False)),
            ],
        ),
        migrations.CreateModel(
            name='Goal',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=255)),
                ('description', models.TextField(blank=True, null=True)),
                ('target_amount', models.DecimalField(decimal_places=2, max_digits=10)),
                ('unit', models.CharField(max_length=50)),
            ],
        ),
        migrations.CreateModel(
            name='User',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('last_login', models.DateTimeField(blank=True, null=True, verbose_name='last login')),
                ('is_superuser', models.BooleanField(default=False, help_text='Designates that this user has all permissions without explicitly assigning them.', verbose_name='superuser status')),
                ('username', models.CharField(max_length=50, unique=True)),
                ('age', models.IntegerField()),
                ('gender', models.CharField(max_length=10)),
                ('height', models.DecimalField(decimal_places=2, max_digits=5)),
                ('weight', models.DecimalField(decimal_places=2, max_digits=5)),
                ('email', models.EmailField(max_length=254, unique=True)),
                ('password', models.CharField(max_length=255)),
                ('is_active', models.BooleanField(default=False)),
                ('is_staff', models.BooleanField(default=False)),
                ('date_joined', models.DateTimeField(auto_now_add=True)),
                ('prevalentStroke', models.BooleanField(default=False)),
                ('prevalentHypertension', models.BooleanField(default=False)),
                ('diabetes', models.BooleanField(default=False)),
                ('dob', models.DateField(blank=True, null=True)),
                ('currentSmoker', models.BooleanField(default=False)),
                ('isHealthy', models.BooleanField(default=True)),
                ('groups', models.ManyToManyField(blank=True, help_text='The groups this user belongs to. A user will get all permissions granted to each of their groups.', related_name='user_set', related_query_name='user', to='auth.group', verbose_name='groups')),
                ('user_permissions', models.ManyToManyField(blank=True, help_text='Specific permissions for this user.', related_name='user_set', related_query_name='user', to='auth.permission', verbose_name='user permissions')),
            ],
            options={
                'db_table': 'users',
            },
        ),
        migrations.CreateModel(
            name='EmailConfirmation',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('confirmation_code', models.CharField(max_length=6)),
                ('created_at', models.DateTimeField(auto_now_add=True)),
                ('is_confirmed', models.BooleanField(default=False)),
                ('user', models.OneToOneField(on_delete=django.db.models.deletion.CASCADE, related_name='email_confirmation', to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='NutritionalIntake',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('timestamp', models.DateTimeField()),
                ('food_name', models.CharField(max_length=255)),
                ('protein', models.DecimalField(decimal_places=2, max_digits=10)),
                ('fat', models.DecimalField(decimal_places=2, max_digits=10)),
                ('carbohydrates', models.DecimalField(decimal_places=2, max_digits=10)),
                ('minerals', models.DecimalField(decimal_places=2, max_digits=10)),
                ('calories', models.DecimalField(decimal_places=2, max_digits=10)),
                ('quantity', models.CharField(default='100 grams', max_length=255)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
        ),
        migrations.CreateModel(
            name='DailyHealthRecord',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('sex', models.IntegerField(choices=[(0, 'Female'), (1, 'Male')])),
                ('age', models.IntegerField()),
                ('currentSmoker', models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])),
                ('cigsPerDay', models.IntegerField(blank=True, null=True)),
                ('BPmeds', models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])),
                ('prevalentStroke', models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])),
                ('prevalentHyp', models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])),
                ('diabetes', models.IntegerField(choices=[(0, 'No'), (1, 'Yes')])),
                ('totChol', models.DecimalField(decimal_places=2, max_digits=5)),
                ('sysBP', models.DecimalField(decimal_places=2, max_digits=5)),
                ('diaBP', models.DecimalField(decimal_places=2, max_digits=5)),
                ('BMI', models.DecimalField(decimal_places=2, max_digits=5)),
                ('heartRate', models.IntegerField()),
                ('glucose', models.DecimalField(decimal_places=2, max_digits=5)),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'db_table': 'daily_health_records',
                'unique_together': {('user', 'date')},
            },
        ),
        migrations.CreateModel(
            name='UserDailyGoalStatus',
            fields=[
                ('id', models.BigAutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('date', models.DateField()),
                ('amount_achieved', models.DecimalField(decimal_places=2, max_digits=10)),
                ('goal', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to='user.goal')),
                ('user', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'unique_together': {('user', 'goal', 'date')},
            },
        ),
    ]
