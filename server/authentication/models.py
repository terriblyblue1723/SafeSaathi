from django.db import models

class AadhaarUser(models.Model):
    aadhaar_number = models.CharField(max_length=12, primary_key=True, unique=True)
    phone_number = models.CharField(max_length=15, blank=True, null=True)
    name = models.CharField(max_length=255, blank=True, null=True)
    created_at = models.DateTimeField(auto_now_add=True)
    last_active = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"User {self.aadhaar_number}"
