from . import views 
from django.urls import path


urlpatterns = [
    path('', views.home, name='home'),
    path('about/', views.about, name='about'),
    path('contact/', views.contact, name='contact'),
    path("projects/", views.projects, name='projects'),
    path("states/", views.states, name="states"),
    # path("engage/", views.engage, name="engage"),
    # path("transparency/", views.transparency, name="transparency"),
    path("login/", views.login_view, name="login"),
    path("register/", views.register_view, name="register"),
    path("logout/", views.logout_view, name="logout"),
    path("profile/", views.profile, name="profile"),
    path("projects/<slug:slug>/", views.project_detail, name="project_detail"),
    path("subscribe/", views.subscribe_project, name="subscribe_project"),
    path("feedback/", views.submit_feedback, name="submit_feedback"),
    path("issues/report/", views.report_issue, name="report_issue"),
    path("poll/vote/", views.vote_poll, name="vote_poll"),
]

    
