import uuid
from rest_framework import status
from rest_framework.response import Response
from rest_framework.views import APIView
from .models import EmergencyContact, User, SOSRequest, SOSLocation, VideoEvidence, ProtectedVideoBackup, Announcement
from .serializers import (
    EmergencyContactSerializer, SOSRequestSerializer, 
    SOSLocationSerializer, VideoEvidenceSerializer, AnnouncementSerializer
)
from .utils import generate_live_location_url, send_emergency_notifications
from django.http import JsonResponse, FileResponse, Http404
from django.shortcuts import get_object_or_404
from django.views import View
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from authentication.models import AadhaarUser
from django.views.decorators.csrf import csrf_exempt
from django.utils.decorators import method_decorator
from rest_framework.permissions import AllowAny, IsAdminUser
import re
from django.core.files.base import ContentFile
import os
import shutil

def validate_aadhaar(aadhaar_number):
    """Validate Aadhaar number format"""
    if not aadhaar_number:
        return False
    # Remove any spaces or special characters
    aadhaar_number = re.sub(r'\D', '', aadhaar_number)
    # Check if it's exactly 12 digits
    return len(aadhaar_number) == 12

@csrf_exempt
@api_view(['POST'])
@authentication_classes([])
@permission_classes([AllowAny])
def create_sos(request):
    """
    Create an SOS request for a user identified by Aadhaar number
    """
    try:
        aadhaar_number = request.data.get('aadhaar_number')
        
        # Validate Aadhaar number
        if not validate_aadhaar(aadhaar_number):
            return Response({
                'error': 'Invalid Aadhaar number format. Must be 12 digits.'
            }, status=status.HTTP_400_BAD_REQUEST)

        # Clean Aadhaar number (remove any spaces or special characters)
        aadhaar_number = re.sub(r'\D', '', aadhaar_number)
        
        # Get user or return 404
        user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
        
        # Create SOS request
        sos_request = SOSRequest.objects.create(
            user=user,
            location=request.data.get('location'),
            message=request.data.get('message')
        )

        # Create initial location entry if coordinates provided
        location_url = None
        if 'latitude' in request.data and 'longitude' in request.data:
            location = SOSLocation.objects.create(
                sos_request=sos_request,
                latitude=request.data['latitude'],
                longitude=request.data['longitude'],
                accuracy=request.data.get('accuracy')
            )
            location_url = f"https://www.google.com/maps?q={location.latitude},{location.longitude}"

        # Get emergency contacts
        emergency_contacts = user.emergency_contacts.all().values('name', 'phone_number')
        
        # Send notifications to all emergency contacts
        notification_results = send_emergency_notifications(
            user_name=user.name,
            contacts=emergency_contacts,
            location_url=location_url,
            message=sos_request.message
        )

        return Response({
            'sos_id': sos_request.id,
            'token': str(sos_request.token),
            'timestamp': sos_request.timestamp,
            'notifications': notification_results,
            'message': 'SOS created and notifications sent to emergency contacts'
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        return Response({
            'error': str(e),
            'message': 'Failed to create SOS request'
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['POST'])
@authentication_classes([])
@permission_classes([AllowAny])
def update_sos_location(request, token):
    """
    Update SOS location using the token
    """
    try:
        sos_request = get_object_or_404(SOSRequest, token=token, is_active=True)
        
        serializer = SOSLocationSerializer(data={
            'latitude': request.data.get('latitude'),
            'longitude': request.data.get('longitude'),
            'accuracy': request.data.get('accuracy')
        })
        
        if serializer.is_valid():
            location = SOSLocation.objects.create(
                sos_request=sos_request,
                **serializer.validated_data
            )
            return Response({
                'location_id': location.id,
                'timestamp': location.timestamp
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['GET'])
@authentication_classes([])
@permission_classes([AllowAny])
def track_live_location(request, token):
    """Get the latest location for an SOS request"""
    try:
        sos_request = get_object_or_404(SOSRequest, token=token)
        latest_location = SOSLocation.objects.filter(sos_request=sos_request).first()
        
        if latest_location:
            serializer = SOSLocationSerializer(latest_location)
            return Response(serializer.data)
        return Response({'error': 'No location data available'}, status=status.HTTP_404_NOT_FOUND)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['POST'])
@authentication_classes([])
@permission_classes([])
def deactivate_sos(request, token):
    """Deactivate an active SOS request"""
    try:
        sos_request = get_object_or_404(SOSRequest, token=token, is_active=True)
        sos_request.is_active = False
        sos_request.save()
        
        return Response({'message': 'SOS request deactivated successfully'})
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['POST'])
@authentication_classes([])
@permission_classes([])
def add_emergency_contact(request):
    """
    Add emergency contact for a user
    Expects: {
        "aadhaar_number": "123456789012",
        "contact_phone": "1234567890",
        "contact_name": "John Doe",
        "relation": "Friend"
    }
    """
    try:
        aadhaar_number = request.data.get('aadhaar_number')
        if not aadhaar_number:
            return Response({'error': 'Aadhaar number is required'}, status=status.HTTP_400_BAD_REQUEST)

        # Get or create user based on Aadhaar
        user, created = AadhaarUser.objects.get_or_create(aadhaar_number=aadhaar_number)
        
        # Create the contact using serializer
        serializer = EmergencyContactSerializer(data={
            'name': request.data.get('contact_name'),
            'phone_number': request.data.get('contact_phone'),
            'relation': request.data.get('relation', 'Others')
        }, context={'user': user})
        
        if serializer.is_valid():
            contact = serializer.save()
            return Response({
                'contact_id': contact.id,
                'name': contact.name,
                'phone_number': contact.phone_number,
                'relation': contact.relation
            }, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
    except Exception as e:
        return Response({'error': str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['GET'])
@authentication_classes([])
@permission_classes([])
def get_emergency_contacts(request, aadhaar_number):
    """Get all emergency contacts for a user"""
    user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
    contacts = EmergencyContact.objects.filter(user=user)
    
    return Response([{
        'id': contact.id,
        'name': contact.name,
        'phone_number': contact.phone_number,
        'relation': contact.relation
    } for contact in contacts])

@csrf_exempt
@api_view(['POST', 'PATCH'])
@authentication_classes([])
@permission_classes([])
def manage_emergency_contact(request):
    """
    Add or update emergency contact for a user
    """
    try:
        # Get or create user based on Aadhaar
        aadhaar_number = request.data.get('aadhaar_number')
        if not aadhaar_number:
            return Response(
                {'error': 'Aadhaar number is required'}, 
                status=status.HTTP_400_BAD_REQUEST
            )

        user = AadhaarUser.objects.filter(aadhaar_number=aadhaar_number).first()
        if not user:
            return Response(
                {'error': 'User not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )

        contact_phone = request.data.get('contact_phone')
        if not contact_phone:
            return Response(
                {'error': 'Contact phone number is required'}, 
                status=status.HTTP_400_BAD_REQUEST
            )

        # Map client field names to model field names
        contact_data = {
            'name': request.data.get('contact_name'),
            'phone_number': contact_phone,
            'relation': request.data.get('relation', 'Others')
        }

        if request.method == 'PATCH':
            # Update existing contact
            try:
                contact = EmergencyContact.objects.get(
                    user=user, 
                    phone_number=contact_phone
                )
                serializer = EmergencyContactSerializer(
                    contact, 
                    data=contact_data, 
                    partial=True,
                    context={'user': user}
                )
            except EmergencyContact.DoesNotExist:
                return Response(
                    {'error': 'Contact not found'}, 
                    status=status.HTTP_404_NOT_FOUND
                )
        else:
            # Create new contact
            # Check if contact already exists
            existing_contact = EmergencyContact.objects.filter(
                user=user, 
                phone_number=contact_phone
            ).first()
            
            if existing_contact:
                return Response(
                    {'error': 'Contact with this phone number already exists'}, 
                    status=status.HTTP_400_BAD_REQUEST
                )
                
            serializer = EmergencyContactSerializer(
                data=contact_data,
                context={'user': user}
            )

        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_200_OK)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['DELETE'])
def delete_emergency_contact(request):
    """
    Delete an emergency contact
    """
    try:
        aadhaar_number = request.data.get('aadhaar_number')
        contact_phone = request.data.get('contact_phone')

        if not aadhaar_number or not contact_phone:
            return Response(
                {'error': 'Both Aadhaar number and contact phone are required'}, 
                status=status.HTTP_400_BAD_REQUEST
            )

        user = AadhaarUser.objects.filter(aadhaar_number=aadhaar_number).first()
        if not user:
            return Response(
                {'error': 'User not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )

        try:
            contact = EmergencyContact.objects.get(
                user=user, 
                phone_number=contact_phone
            )
            contact.delete()
            return Response(
                {'message': 'Contact deleted successfully'}, 
                status=status.HTTP_200_OK
            )
        except EmergencyContact.DoesNotExist:
            return Response(
                {'error': 'Contact not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )

    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@api_view(['GET'])
def get_emergency_contacts(request, aadhaar_number):
    """
    Get all emergency contacts for a user
    """
    try:
        user = AadhaarUser.objects.filter(aadhaar_number=aadhaar_number).first()
        if not user:
            return Response(
                {'error': 'User not found'}, 
                status=status.HTTP_404_NOT_FOUND
            )

        contacts = EmergencyContact.objects.filter(user=user)
        serializer = EmergencyContactSerializer(contacts, many=True)
        return Response(serializer.data, status=status.HTTP_200_OK)

    except Exception as e:
        return Response(
            {'error': str(e)}, 
            status=status.HTTP_500_INTERNAL_SERVER_ERROR
        )

@csrf_exempt
@api_view(['POST'])
@authentication_classes([])
@permission_classes([AllowAny])
def upload_video(request):
    """
    Upload a video file and associate it with a user
    """
    try:
        # Get form data - check both aadhaar and aadhaar_number fields
        aadhaar_number = (
            request.POST.get('aadhaar_number') or 
            request.POST.get('aadhaar') or 
            request.data.get('aadhaar_number') or 
            request.data.get('aadhaar')
        )
        password = (
            request.POST.get('password') or
            request.data.get('password')
        )
        video_file = request.FILES.get('video')
        
        # Validate required fields
        if not aadhaar_number:
            return Response({
                'error': 'Aadhaar number is required'
            }, status=status.HTTP_400_BAD_REQUEST)
            
        if not password:
            return Response({
                'error': 'Password is required'
            }, status=status.HTTP_400_BAD_REQUEST)
            
        if not video_file:
            return Response({
                'error': 'Video file is required'
            }, status=status.HTTP_400_BAD_REQUEST)

        # Get user
        try:
            user = AadhaarUser.objects.get(aadhaar_number=aadhaar_number)
            # Verify password
            if not user.check_password(password):
                return Response({
                    'error': 'Invalid password'
                }, status=status.HTTP_401_UNAUTHORIZED)
        except AadhaarUser.DoesNotExist:
            return Response({
                'error': 'User not found'
            }, status=status.HTTP_404_NOT_FOUND)

        # Get optional data
        location = request.POST.get('location') or request.data.get('location')
        latitude = request.POST.get('latitude') or request.data.get('latitude')
        longitude = request.POST.get('longitude') or request.data.get('longitude')
        description = request.POST.get('description') or request.data.get('description')

        # Create video evidence
        video_evidence = VideoEvidence.objects.create(
            user=user,
            video_file=video_file,
            location=location,
            latitude=latitude,
            longitude=longitude,
            description=description,
            file_size=video_file.size if video_file else None
        )

        # Create protected backup
        try:
            # Create protected backup instance
            protected_backup = ProtectedVideoBackup.objects.create(
                original_video=video_evidence,
                user=user,
                file_size=video_file.size
            )
            
            # Set the password
            combined_password = f"{aadhaar_number}:{password}"
            protected_backup.set_password(combined_password)
            protected_backup.save()

            # Save the video file separately to avoid encoding issues
            video_name = os.path.basename(video_file.name)
            protected_backup.video_file.save(video_name, video_file, save=True)
            
            backup_created = True
            backup_id = protected_backup.id
        except Exception as e:
            print(f"Failed to create protected backup: {str(e)}")
            backup_created = False
            backup_id = None

        # Return response with backup info
        return Response({
            'message': 'Video uploaded successfully',
            'video_id': video_evidence.id,
            'protected_backup': {
                'created': backup_created,
                'id': backup_id
            }
        }, status=status.HTTP_201_CREATED)
        
    except Exception as e:
        import traceback
        print("Exception:", str(e))
        print("Traceback:", traceback.format_exc())
        return Response({
            'error': 'Failed to upload video',
            'detail': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['GET'])
@authentication_classes([])
@permission_classes([AllowAny])
def get_user_videos(request, aadhaar_number):
    """Get all videos for a user"""
    try:
        user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
        videos = VideoEvidence.objects.filter(user=user)
        serializer = VideoEvidenceSerializer(videos, many=True, context={'request': request})
        return Response(serializer.data)
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['GET', 'DELETE'])
@authentication_classes([])
@permission_classes([AllowAny])
def manage_video(request, aadhaar_number, video_id):
    """Get or delete a specific video"""
    try:
        user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
        video = get_object_or_404(VideoEvidence, id=video_id, user=user)
        
        if request.method == 'GET':
            serializer = VideoEvidenceSerializer(video, context={'request': request})
            return Response(serializer.data)
        
        elif request.method == 'DELETE':
            # Delete the actual files
            if video.video_file:
                if os.path.exists(video.video_file.path):
                    os.remove(video.video_file.path)
            if video.thumbnail:
                if os.path.exists(video.thumbnail.path):
                    os.remove(video.thumbnail.path)
            
            video.delete()
            return Response({'message': 'Video deleted successfully'})
            
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@csrf_exempt
@api_view(['GET'])
@authentication_classes([])
@permission_classes([AllowAny])
def get_sos_videos(request, token):
    """Get all videos associated with an SOS request"""
    try:
        sos_request = get_object_or_404(SOSRequest, token=token)
        videos = VideoEvidence.objects.filter(sos_request=sos_request)
        serializer = VideoEvidenceSerializer(videos, many=True, context={'request': request})
        return Response(serializer.data)
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([AllowAny])
def serve_video(request, aadhaar_number, video_id):
    """Serve video file"""
    try:
        # Get the video evidence
        user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
        video = get_object_or_404(VideoEvidence, id=video_id, user=user)
        
        # Check if file exists
        if not video.video_file or not os.path.exists(video.video_file.path):
            raise Http404("Video file not found")
            
        # Open the file in binary mode
        file = open(video.video_file.path, 'rb')
        
        # Create the response
        response = FileResponse(file)
        response['Content-Type'] = 'video/mp4'  # Adjust content type if needed
        response['Content-Disposition'] = f'inline; filename="{os.path.basename(video.video_file.name)}"'
        
        return response
        
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([AllowAny])
def create_protected_backup(request, video_id):
    """Create a password-protected backup of a video"""
    try:
        # Get the original video
        video = get_object_or_404(VideoEvidence, id=video_id)
        password = request.data.get('password')

        if not password:
            return Response({
                'error': 'Password is required'
            }, status=status.HTTP_400_BAD_REQUEST)

        # Create protected backup
        protected_backup = ProtectedVideoBackup(
            original_video=video,
            user=video.user,
            file_size=video.file_size
        )
        protected_backup.set_password(password)

        # Copy the video file
        if video.video_file:
            protected_backup.video_file.save(
                os.path.basename(video.video_file.name),
                ContentFile(video.video_file.read())
            )

        protected_backup.save()

        return Response({
            'message': 'Protected backup created successfully',
            'backup_id': protected_backup.id
        }, status=status.HTTP_201_CREATED)

    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['POST'])
@permission_classes([AllowAny])
def access_protected_video(request, backup_id):
    """Access a password-protected video backup"""
    try:
        backup = get_object_or_404(ProtectedVideoBackup, id=backup_id)
        aadhaar_number = request.data.get('aadhaar_number')
        password = request.data.get('password')

        if not aadhaar_number or not password:
            return Response({
                'error': 'Both Aadhaar number and password are required'
            }, status=status.HTTP_400_BAD_REQUEST)

        # Combine Aadhaar and password for verification
        combined_password = f"{aadhaar_number}:{password}"
        
        if not backup.check_password(combined_password):
            return Response({
                'error': 'Invalid credentials'
            }, status=status.HTTP_401_UNAUTHORIZED)

        # Record access
        backup.record_access()

        # Check if file exists
        if not backup.video_file or not os.path.exists(backup.video_file.path):
            raise Http404("Protected video file not found")

        # Open and serve the file
        file = open(backup.video_file.path, 'rb')
        response = FileResponse(file)
        response['Content-Type'] = 'video/mp4'
        response['Content-Disposition'] = f'inline; filename="{os.path.basename(backup.video_file.name)}"'
        
        return response

    except Http404:
        raise
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([AllowAny])
def list_protected_backups(request, aadhaar_number):
    """List all protected backups for a user"""
    try:
        user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
        backups = ProtectedVideoBackup.objects.filter(user=user)
        
        return Response([{
            'id': backup.id,
            'created_at': backup.created_at,
            'file_size': backup.file_size,
            'last_accessed': backup.last_accessed,
            'access_count': backup.access_count
        } for backup in backups])

    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

@api_view(['GET'])
@permission_classes([AllowAny])
def list_announcements(request):
    """List all active announcements"""
    announcements = Announcement.objects.filter(is_active=True)
    serializer = AnnouncementSerializer(
        announcements, 
        many=True,
        context={'request': request}
    )
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([AllowAny])
def get_announcement(request, announcement_id):
    """Get a specific announcement by ID"""
    try:
        announcement = Announcement.objects.get(id=announcement_id)
        serializer = AnnouncementSerializer(
            announcement,
            context={'request': request}
        )
        return Response(serializer.data)
    except Announcement.DoesNotExist:
        return Response(
            {'error': 'Announcement not found'},
            status=status.HTTP_404_NOT_FOUND
        )

@api_view(['POST'])
@permission_classes([IsAdminUser])  # Only admin users can create announcements
def create_announcement(request):
    """Create a new announcement"""
    try:
        serializer = AnnouncementSerializer(
            data=request.data,
            context={'request': request}
        )
        if serializer.is_valid():
            serializer.save()
            return Response(
                serializer.data,
                status=status.HTTP_201_CREATED
            )
        return Response(
            serializer.errors,
            status=status.HTTP_400_BAD_REQUEST
        )
    except Exception as e:
        return Response({
            'error': str(e)
        }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)