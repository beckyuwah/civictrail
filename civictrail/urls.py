from . import views 
from users import views as user_views
from django.urls import path
from django.contrib.auth import views as auth_views



urlpatterns = [
    path('', views.home, name='home'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path("projects/", views.projects, name='projects'),
    path("states/", views.states, name="states"),
    # path("engage/", views.engage, name="engage"),
    # path("transparency/", views.transparency, name="transparency"),
    path('login/', auth_views.LoginView.as_view(template_name='users/login.html'), name='login'),
    path('logout/', auth_views.LogoutView.as_view(template_name='users/logout.html'), name='logout'),
    path("register/", views.register_view, name="register"),
    path("profile/", user_views.profile, name="profile"),
    path("projects/<slug:slug>/", views.project_detail, name="project_detail"),
    path("subscribe/", views.subscribe_project, name="subscribe_project"),
    path("feedback/", views.submit_feedback, name="submit_feedback"),
    path("issues/report/", views.report_issue, name="report_issue"),
    path("poll/vote/", views.vote_poll, name="vote_poll"),
    path("offline/", views.offline, name="offline"),
]

    


