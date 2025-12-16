from django.contrib import admin
from .models import Profile 

admin.site.register(Profile) 

# Register your models here.


# class ProfileAdmin(admin.ModelAdmin):
#     list_display = ('user', 'image')  # Columns shown in the admin list
#     search_fields = ('user__username', 'user__email')  # Enable search by related user fields

# admin.site.register(Profile, ProfileAdmin)
