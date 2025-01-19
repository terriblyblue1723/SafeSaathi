from django.urls import path
from . import views

urlpatterns = [
    path('user', views.get_or_create_user, name='get_or_create_user'),
    path('user/<str:aadhaar_number>', views.get_user_info, name='get_user_info'),
] 