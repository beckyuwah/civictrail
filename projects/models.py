from django.db import models
from django.utils.text import slugify

class State(models.Model):
    name = models.CharField(max_length=80, unique=True)
    slug = models.SlugField(unique=True, blank=True)

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    def __str__(self):
        return self.name

class Project(models.Model):
    title = models.CharField(max_length=255)
    description = models.TextField(blank=True)
    state = models.ForeignKey(State, on_delete=models.PROTECT, related_name="projects")
    status = models.CharField(
        max_length=20,
        choices=[
            ("planned", "Planned"),
            ("active", "Active"),
            ("completed", "Completed"),
        ],
        default="planned",
    )
    budget = models.DecimalField(max_digits=14, decimal_places=2, null=True, blank=True)
    progress = models.PositiveIntegerField(default=0)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.title} ({self.state})"
