from django.urls import path
from . import views

urlpatterns = [
    path('contacts/add/', views.add_emergency_contact, name='add_emergency_contact'),
    path('contacts/manage/', views.manage_emergency_contact, name='manage_emergency_contact'),
    path('contacts/delete/', views.delete_emergency_contact, name='delete_emergency_contact'),
    path('contacts/<str:aadhaar_number>/', views.get_emergency_contacts, name='get_emergency_contacts'),
    
    # SOS endpoints
    path('create/', views.create_sos, name='create_sos'),
    path('<uuid:token>/locations/', views.update_sos_location, name='update_sos_location'),
    path('<uuid:token>/track/', views.track_live_location, name='track_live_location'),
    path('<uuid:token>/deactivate/', views.deactivate_sos, name='deactivate_sos'),
    
    # Video evidence endpoints
    path('videos/upload/', views.upload_video, name='upload_video'),
    path('videos/<str:aadhaar_number>/', views.get_user_videos, name='get_user_videos'),
    path('videos/<str:aadhaar_number>/<int:video_id>/', views.manage_video, name='manage_video'),
    path('sos/<uuid:token>/videos/', views.get_sos_videos, name='get_sos_videos'),
    path('videos/<str:aadhaar_number>/<int:video_id>/view/', views.serve_video, name='serve_video'),
    
    # Protected video backup endpoints
    path('videos/<int:video_id>/protect/', views.create_protected_backup, name='create_protected_backup'),
    path('protected-videos/<int:backup_id>/access/', views.access_protected_video, name='access_protected_video'),
    path('protected-videos/<str:aadhaar_number>/', views.list_protected_backups, name='list_protected_backups'),
    
    # Announcement endpoints
    path('announcements/', views.list_announcements, name='list_announcements'),
    path('announcements/create/', views.create_announcement, name='create_announcement'),
    path('announcements/<int:announcement_id>/', views.get_announcement, name='get_announcement'),
]

