from . import views 
from django.urls import path

urlpatterns = [
    path('register/', views.register_view, name='register'),
    path("profile/", views.profile, name="profile"),
    path("settings/", views.settings, name="settings"),
   
]