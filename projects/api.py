from rest_framework import serializers, viewsets, permissions
from .models import Project

class ProjectSerializer(serializers.ModelSerializer):
    class Meta:
        model = Project 
        fields = "__all__"

class ProjectViewSet(viewsets.ModelViewSet):
    queryset = Project.objects.all().order_by("-id")
    serializer_class = ProjectSerializer
    permission_classes = [permissions.IsAuthenticated]
