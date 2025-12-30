from django.shortcuts import render, redirect
from django.contrib.auth.forms import UserCreationForm
from django.contrib import messages
from django.contrib.auth import login
from .forms import UserRegisterForm
from django.contrib.auth.decorators import login_required  
from rest_framework.decorators import api_view
from rest_framework.response import Response
from django.contrib.auth.models import User
from rest_framework import status
from rest_framework import generics

# Create your views here.
# def register(request):
#     if request.method == 'POST':
#         form = UserCreationForm(request.POST)
#         if form.is_valid():
#             form.save()
#             username = form.cleaned_data.get('username')
#             messages.success(request, f'Registration successful for {username}.')
#             # return redirect('civictrail:home')
#             return redirect('login')
#     else:
#         form = UserCreationForm()
#     return render(request, 'users/register.html', {'form': form})


def register_view(request):
    if request.method == 'POST':
        form = UserRegisterForm(request.POST)
        if form.is_valid():
            user = form.save(commit=False)
            user.set_password(form.cleaned_data['password'])  # hash password
            user.save()
            # login(request, user)  # auto-login after registration
            messages.success(request, 'Registration successful! Welcome, {}.'.format(user.username))
            return redirect('login')  # redirect to login after registration
    else:
        form = UserRegisterForm()
    return render(request, 'users/register.html', {'form': form})

@login_required
def profile(request):
    return render(request, 'users/profile.html', {'title': 'User Profile'})    

def settings(request):
    return render(request, 'users/settings.html')

@api_view(['POST'])
def register_user(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')

    if not username or not email or not password:
        return Response({'error': 'All fields are required'}, status=status.HTTP_400_BAD_REQUEST)
    
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username already exists'}, status=status.HTTP_400_BAD_REQUEST)

    User.objects.create_user(username=username, email=email, password=password)
    return Response({'message': 'User registered successfully'}, status=status.HTTP_201_CREATED)