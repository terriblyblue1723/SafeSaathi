from django.db import models
from django.utils import timezone
from authentication.models import AadhaarUser
import uuid
from django.contrib.auth.hashers import make_password, check_password

class User(models.Model):
    aadhaar_number = models.CharField(max_length=12, primary_key=True)
    name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=15)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.name} ({self.aadhaar_number})"

class EmergencyContact(models.Model):
    user = models.ForeignKey('authentication.AadhaarUser', on_delete=models.CASCADE, related_name='emergency_contacts')
    name = models.CharField(max_length=100)
    phone_number = models.CharField(max_length=15)
    relation = models.CharField(max_length=50, default='Others')  # Family, Friends, Work, Others
    created_at = models.DateTimeField(default=timezone.now)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        unique_together = ('user', 'phone_number')

    def __str__(self):
        return f"{self.name} ({self.relation}) - {self.user.aadhaar_number}"

class SOSRequest(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey('authentication.AadhaarUser', on_delete=models.CASCADE, related_name='sos_requests')
    token = models.UUIDField(default=uuid.uuid4, unique=True)
    message = models.TextField(blank=True, null=True)
    location = models.CharField(max_length=255, blank=True, null=True)
    is_active = models.BooleanField(default=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"SOS Request {self.id} - {self.user.aadhaar_number}"

class SOSLocation(models.Model):
    sos_request = models.ForeignKey(SOSRequest, on_delete=models.CASCADE, related_name='locations')
    latitude = models.FloatField()
    longitude = models.FloatField()
    accuracy = models.FloatField(null=True, blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)

    class Meta:
        ordering = ['-timestamp']

    def __str__(self):
        return f"Location update for SOS {self.sos_request.id} at {self.timestamp}"

class VideoEvidence(models.Model):
    id = models.AutoField(primary_key=True)
    user = models.ForeignKey('authentication.AadhaarUser', on_delete=models.CASCADE, related_name='video_evidence')
    sos_request = models.ForeignKey(SOSRequest, on_delete=models.SET_NULL, related_name='videos', null=True, blank=True)
    video_file = models.FileField(upload_to='video_evidence/%Y/%m/%d/')
    thumbnail = models.ImageField(upload_to='video_thumbnails/%Y/%m/%d/', null=True, blank=True)
    duration = models.FloatField(null=True, blank=True)  # Duration in seconds
    file_size = models.BigIntegerField(null=True, blank=True)  # Size in bytes
    location = models.CharField(max_length=255, blank=True, null=True)
    latitude = models.FloatField(null=True, blank=True)
    longitude = models.FloatField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    description = models.TextField(blank=True, null=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Video Evidence {self.id} - {self.user.aadhaar_number} at {self.created_at}"

class ProtectedVideoBackup(models.Model):
    id = models.AutoField(primary_key=True)
    original_video = models.ForeignKey(VideoEvidence, on_delete=models.SET_NULL, null=True, related_name='backups')
    user = models.ForeignKey('authentication.AadhaarUser', on_delete=models.CASCADE, related_name='protected_videos')
    video_file = models.FileField(upload_to='protected_videos/%Y/%m/%d/')
    file_size = models.BigIntegerField(null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    access_password = models.CharField(max_length=128)  # Stores hashed password
    last_accessed = models.DateTimeField(null=True, blank=True)
    access_count = models.IntegerField(default=0)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"Protected Video Backup {self.id} - {self.user.aadhaar_number}"

    def set_password(self, raw_password):
        self.access_password = make_password(raw_password)
        
    def check_password(self, raw_password):
        return check_password(raw_password, self.access_password)

    def record_access(self):
        self.access_count += 1
        self.last_accessed = timezone.now()
        self.save()

class Announcement(models.Model):
    PRIORITY_CHOICES = [
        ('high', 'High'),
        ('medium', 'Medium'),
        ('normal', 'Normal'),
    ]

    title = models.CharField(max_length=200)
    body = models.TextField()
    image = models.ImageField(upload_to='announcements/%Y/%m/%d/', null=True, blank=True)
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    priority = models.CharField(max_length=10, choices=PRIORITY_CHOICES, default='normal')
    is_active = models.BooleanField(default=True)

    class Meta:
        ordering = ['-created_at']

    def __str__(self):
        return f"{self.title} ({self.priority})"

    @property
    def image_url(self):
        if self.image:
            return self.image.url
        return None
