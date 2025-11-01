from django.db import models

# Create your models here.
class Project(models.Model):
    name = models.CharField(max_length=200)
    slug = models.SlugField(unique=True)
    level = models.CharField(max_length=50)  # e.g., federal, state, local
    status = models.CharField(max_length=50)  # e.g., active, completed, planned
    summary = models.TextField()
    progress = models.IntegerField()  # percentage
    budget = models.DecimalField(max_digits=15, decimal_places=2)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name
