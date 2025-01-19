from rest_framework import serializers
from .models import User, EmergencyContact, SOSRequest, SOSLocation, VideoEvidence, Announcement
from django.urls import reverse

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['aadhaar_number', 'name', 'phone_number', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at']

class EmergencyContactSerializer(serializers.ModelSerializer):
    class Meta:
        model = EmergencyContact
        fields = ['name', 'phone_number', 'relation', 'created_at', 'updated_at']
        read_only_fields = ['created_at', 'updated_at']

    def create(self, validated_data):
        user = self.context.get('user')
        if not user:
            raise serializers.ValidationError("User context is required")
        return EmergencyContact.objects.create(user=user, **validated_data)

    def update(self, instance, validated_data):
        instance.name = validated_data.get('name', instance.name)
        instance.phone_number = validated_data.get('phone_number', instance.phone_number)
        instance.relation = validated_data.get('relation', instance.relation)
        instance.save()
        return instance

class SOSLocationSerializer(serializers.ModelSerializer):
    class Meta:
        model = SOSLocation
        fields = ['latitude', 'longitude', 'accuracy', 'timestamp']
        read_only_fields = ['timestamp']

class SOSRequestSerializer(serializers.ModelSerializer):
    locations = SOSLocationSerializer(many=True, read_only=True)
    
    class Meta:
        model = SOSRequest
        fields = ['id', 'token', 'message', 'location', 'is_active', 'timestamp', 'locations']
        read_only_fields = ['id', 'token', 'timestamp']

class VideoEvidenceSerializer(serializers.ModelSerializer):
    video_url = serializers.SerializerMethodField()
    
    class Meta:
        model = VideoEvidence
        fields = [
            'id', 'video_url', 'created_at', 'file_size', 
            'location', 'latitude', 'longitude', 'description'
        ]
    
    def get_video_url(self, obj):
        if obj.video_file:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(
                    reverse('serve_video', kwargs={
                        'aadhaar_number': obj.user.aadhaar_number,
                        'video_id': obj.id
                    })
                )
        return None

class AnnouncementSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()
    
    class Meta:
        model = Announcement
        fields = [
            'id', 'title', 'body', 'image_url', 'created_at',
            'updated_at', 'priority', 'is_active'
        ]
    
    def get_image_url(self, obj):
        if obj.image:
            request = self.context.get('request')
            if request:
                return request.build_absolute_uri(obj.image.url)
        return None