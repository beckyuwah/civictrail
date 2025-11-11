from django.shortcuts import render, get_object_or_404
from .models import Project, State

def project_list(request):
    state_slug = request.GET.get("state")
    projects = Project.objects.select_related("state")
    if state_slug:
        projects = projects.filter(state__slug=state_slug)
    states = State.objects.all()
    return render(request, "projects/list.html", {"projects": projects, "states": states})

def project_detail(request, pk):
    project = get_object_or_404(Project, pk=pk)
    return render(request, "projects/detail.html", {"project": project})

