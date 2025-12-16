from django import forms
from django.contrib.auth.models import User
from django.core.exceptions import ValidationError

class UserRegisterForm(forms.ModelForm):
    state=forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={'placeholder': 'Enter state of origin'}))
    city=forms.CharField(max_length=100, required=False, widget=forms.TextInput(attrs={'placeholder': 'Enter city of residence'}))
    password = forms.CharField(widget=forms.PasswordInput())
    confirm_password = forms.CharField(widget=forms.PasswordInput(attrs={'placeholder': 'Re-enter password'}))

    class Meta:
        model = User
        fields = ['username', 'first_name', 'last_name', 'email', 'state', 'city', 'password', 'confirm_password']



        widgets = {
            'username': forms.TextInput(),
            'first_name': forms.TextInput(),
            'last_name': forms.TextInput(),
            'email': forms.EmailInput(),
            'state': forms.TextInput(),
            'city': forms.TextInput(),
        }

    def clean(self):
        cleaned_data = super().clean()
        password = cleaned_data.get("password")
        confirm_password = cleaned_data.get("confirm_password")

        if password != confirm_password:
            raise ValidationError("Passwords do not match.")

        return cleaned_data
    
class UserUpdateForm(forms.ModelForm):
    email = forms.EmailField(widget=forms.EmailInput(attrs={'placeholder': 'Enter email address'}))

    class Meta:
        model = User
        fields = ['username', 'email']

        widgets = {
            'username': forms.TextInput(attrs={'placeholder': 'Enter username'}),
        }