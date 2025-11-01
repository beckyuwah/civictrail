from django.shortcuts import render
from django.http import HttpResponse
# from .models import Project, Update
from django.utils import timezone 


# Create your views here.
# def home(request):
#     return render(request, "civictrail/home.html" , {"title": "Welcome"})

def home(request):
    # Example filtered data (replace with ORM)
    q = request.GET.get("q", "")
    level = request.GET.get("level", "")
    status = request.GET.get("status", "")

    # Fake demo data structure (swap with Project.objects.filter(...))
    projects = [
        {
            "id": 1, "slug": "north-bridge", "name": "North Bridge Rehabilitation", "level": "federal",
            "status": "active", "summary": "Structural upgrade and lane expansion.",
            "progress": 62, "budget": "$120M", "updated_at": timezone.now()
        },
        {
            "id": 2, "slug": "city-hospital", "name": "City Hospital Upgrade", "level": "state",
            "status": "planned", "summary": "New ICU wing and equipment.",
            "progress": 10, "budget": "$40M", "updated_at": timezone.now()
        },
    ]

    # Basic filtering (replace with ORM filters)
    def match(p):
        return ((not q or q.lower() in p["name"].lower()) and
                (not level or p["level"] == level) and
                (not status or p["status"] == status))

    filtered = [p for p in projects if match(p)]

    updates = [
        {"project_name": "North Bridge Rehabilitation", "title": "Pier concrete poured",
         "body": "Contractor completed pier 3 concrete pour ahead of schedule.",
         "created_at": timezone.now(), "status": "on track"},
        {"project_name": "City Hospital Upgrade", "title": "Environmental assessment approved",
         "body": "EA cleared by state agency; procurement to commence.",
         "created_at": timezone.now(), "status": "planned"},
    ]

    context = {
        "projects": filtered,
        "total_projects": len(projects),
        "updates": updates,
        "last_sync": timezone.now().strftime("%b %d, %Y %H:%M"),
        "kpi": {
            "active_projects": 1,
            "completed_projects": 0,
            "feedback_count": 57,
            "transparency_score": "82/100",
        },
    }
    return render(request, "civictrail/home.html", context)

def about(request):
    return render(request, "civictrail/about.html", {"title": "About Us"})

def contact(request):
    return render(request, "civictrail/contact.html", {"title": "Contact Us"})

def projects(request):
    # later, load projects from DB and pass context
    return render(request, "civictrail/projects.html", {"title": "Projects"})

def engage(request):
    return render(request, "civictrail/engage.html", {"title": "Engage"})

def transparency(request):
    return render(request, "civictrail/transparency.html", {"title": "Transparency"})

# Simple authentication page placeholders
def login_view(request):
    return render(request, "civictrail/login.html", {"title": "Login"})

def register_view(request):
    return render(request, "civictrail/register.html", {"title": "Register"})

def profile(request):
    return render(request, "civictrail/profile.html", {"title": "Profile"})

def logout_view(request):
    # You can implement Django's logout logic later
    return render(request, "civictrail/logout.html", {"title": "Logout"})

def project_detail(request, slug):
    # Fetch project by slug from DB later
    project = {
        "id": 1, "slug": "north-bridge", "name": "North Bridge Rehabilitation", "level": "federal",
        "status": "active", "summary": "Structural upgrade and lane expansion.",
        "progress": 62, "budget": "$120M", "updated_at": timezone.now()
    }
    return render(request, "civictrail/project_detail.html", {"project": project})

def subscribe_project(request):
    # Handle project subscription logic
    return render(request, "civictrail/subscribe.html", {"title": "Subscribe to Project"})
def submit_feedback(request):
    # Handle feedback submission logic
    return render(request, "civictrail/feedback.html", {"title": "Submit Feedback"})

def report_issue(request):
    # Handle issue reporting logic
    return render(request, "civictrail/report_issue.html", {"title": "Report Issue"})
def vote_poll(request):
    # Handle poll voting logic
    return render(request, "civictrail/vote_poll.html", {"title": "Vote in Poll"})   

