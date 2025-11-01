from django.shortcuts import render
from django.http import HttpResponse

# Create your views here.
def register(request):
    return HttpResponse("User registration page")

def profile(request):
    return HttpResponse("User profile page")

def settings(request):
    return HttpResponse("User settings page")
