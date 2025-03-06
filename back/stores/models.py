from django.db import models

# Create your models here.
class NewUser(models.Model):
    username = models.CharField(max_length=30, unique=True)
    password = models.CharField(max_length=15)
    email = models.CharField(max_length=50)
    
class Meta:
        db_table = 'new_users'