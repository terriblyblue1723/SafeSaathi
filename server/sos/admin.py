from django.contrib import admin
from .models import User, EmergencyContact, SOSRequest, SOSLocation, VideoEvidence, ProtectedVideoBackup, Announcement

@admin.register(User)
class UserAdmin(admin.ModelAdmin):
    list_display = ('aadhaar_number', 'name', 'phone_number', 'created_at')
    search_fields = ('aadhaar_number', 'name', 'phone_number')

@admin.register(EmergencyContact)
class EmergencyContactAdmin(admin.ModelAdmin):
    list_display = ('user', 'name', 'phone_number', 'relation')
    list_filter = ('relation',)
    search_fields = ('name', 'phone_number', 'user__aadhaar_number')

@admin.register(SOSRequest)
class SOSRequestAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'is_active', 'timestamp')
    list_filter = ('is_active',)
    search_fields = ('user__aadhaar_number', 'message')

@admin.register(SOSLocation)
class SOSLocationAdmin(admin.ModelAdmin):
    list_display = ('sos_request', 'latitude', 'longitude', 'timestamp')
    list_filter = ('timestamp',)

@admin.register(VideoEvidence)
class VideoEvidenceAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'created_at', 'file_size', 'location')
    list_filter = ('created_at', 'user')
    search_fields = ('user__aadhaar_number', 'location', 'description')
    readonly_fields = ('created_at', 'file_size')

@admin.register(ProtectedVideoBackup)
class ProtectedVideoBackupAdmin(admin.ModelAdmin):
    list_display = ('id', 'user', 'created_at', 'file_size', 'last_accessed', 'access_count')
    list_filter = ('created_at', 'last_accessed')
    search_fields = ('user__aadhaar_number',)
    readonly_fields = ('created_at', 'last_accessed', 'access_count', 'file_size')

@admin.register(Announcement)
class AnnouncementAdmin(admin.ModelAdmin):
    list_display = ('title', 'priority', 'created_at', 'is_active')
    list_filter = ('priority', 'is_active', 'created_at')
    search_fields = ('title', 'body')
    readonly_fields = ('created_at', 'updated_at')
    ordering = ('-created_at',)
    fieldsets = (
        (None, {
            'fields': ('title', 'body', 'priority', 'is_active')
        }),
        ('Media', {
            'fields': ('image',),
            'classes': ('collapse',)
        }),
        ('Timestamps', {
            'fields': ('created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )
