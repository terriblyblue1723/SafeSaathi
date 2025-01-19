from rest_framework import status
from rest_framework.decorators import api_view, permission_classes, authentication_classes
from rest_framework.response import Response
from .models import AadhaarUser
from django.shortcuts import get_object_or_404
from django.views.decorators.csrf import csrf_exempt

@csrf_exempt
@api_view(['GET', 'POST'])
@authentication_classes([])
@permission_classes([])
def get_or_create_user(request):
    """
    Get or create a user based on Aadhaar number.
    GET: Returns a test response
    POST: Expects JSON with at least: {"aadhaar_number": "123456789012"}
    Optionally can include: {"phone_number": "1234567890", "name": "John Doe"}
    """
    if request.method == 'GET':
        return Response({
            'message': 'API is working! Send a POST request with aadhaar_number to create/get user.',
            'example_post_data': {
                'aadhaar_number': '123456789012',
                'phone_number': '1234567890',
                'name': 'John Doe'
            }
        })
    
    aadhaar_number = request.data.get('aadhaar_number')
    
    if not aadhaar_number or len(aadhaar_number) != 12:
        return Response(
            {'error': 'Valid 12-digit Aadhaar number is required'}, 
            status=status.HTTP_400_BAD_REQUEST
        )

    user, created = AadhaarUser.objects.get_or_create(
        aadhaar_number=aadhaar_number,
        defaults={
            'phone_number': request.data.get('phone_number'),
            'name': request.data.get('name')
        }
    )

    # Update user info if provided
    if not created:
        if 'phone_number' in request.data:
            user.phone_number = request.data['phone_number']
        if 'name' in request.data:
            user.name = request.data['name']
        user.save()

    return Response({
        'aadhaar_number': user.aadhaar_number,
        'phone_number': user.phone_number,
        'name': user.name,
        'created': created
    }, status=status.HTTP_200_OK)

@csrf_exempt
@api_view(['GET'])
@authentication_classes([])
@permission_classes([])
def get_user_info(request, aadhaar_number):
    """Get user information based on Aadhaar number"""
    user = get_object_or_404(AadhaarUser, aadhaar_number=aadhaar_number)
    return Response({
        'aadhaar_number': user.aadhaar_number,
        'phone_number': user.phone_number,
        'name': user.name
    }) 