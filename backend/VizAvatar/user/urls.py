from django.urls import path
from .views import UserSignup, UserLogin, AddNutritionalIntakeView, NutritionalSummaryView, ConfirmEmail, ResendConfirmationCode, ValidateTokenView, UpdateDailyGoalStatusView, DailyHealthRecordView

urlpatterns = [
    path('signup/', UserSignup.as_view(), name='user-signup'),
    path('login/', UserLogin.as_view(), name='user-login'),
    path('intake/add/', AddNutritionalIntakeView.as_view(), name='intake-add'),
    path('intake/summary/', NutritionalSummaryView.as_view(), name='intake-summary'),
    path('confirm-email/', ConfirmEmail.as_view(), name='confirm_email'),
    path('resend-confirmation/', ResendConfirmationCode.as_view(), name='resend_confirmation'),
    path('is-user-login/', ValidateTokenView.as_view(), name='is-user-login'),
    path('daily-goal-status/', UpdateDailyGoalStatusView.as_view(), name='daily-goal-status'),
    path('add-daily-health-data', DailyHealthRecordView.as_view())
]
