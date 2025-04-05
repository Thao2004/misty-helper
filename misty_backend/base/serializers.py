from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Caregiver, Patient, HealthInfo

# Serializer for Django's built-in User model.
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'first_name', 'last_name', 'email']

# Serializer for Caregiver
class CaregiverSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')

    class Meta:
        model = Caregiver
        fields = ['id', 'username', 'first_name', 'last_name', 'role', 'hospital', 'date_of_birth']

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        user = User.objects.create(**user_data)
        caregiver = Caregiver.objects.create(user=user, **validated_data)
        return caregiver

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', None)
        if user_data:
            instance.user.username = user_data.get('username', instance.user.username)
            instance.user.first_name = user_data.get('first_name', instance.user.first_name)
            instance.user.last_name = user_data.get('last_name', instance.user.last_name)
            instance.user.save()
        
        instance.hospital = validated_data.get('hospital', instance.hospital)
        instance.date_of_birth = validated_data.get('date_of_birth', instance.date_of_birth)
        instance.role = validated_data.get('role', instance.role)
        instance.save()
        return instance

# Serializer for Patient
class PatientSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')

    class Meta:
        model = Patient
        fields = ['id', 'username', 'first_name', 'last_name', 'caregiver', 'address', 'date_of_birth']

    def create(self, validated_data):
        # Extract user fields from the validated data
        user_data = validated_data.pop('user')
        user = User.objects.create(**user_data)
        patient = Patient.objects.create(user=user, **validated_data)
        return patient

    def update(self, instance, validated_data):
        # Update related user fields if present
        user_data = validated_data.pop('user', None)
        if user_data:
            instance.user.username = user_data.get('username', instance.user.username)
            instance.user.first_name = user_data.get('first_name', instance.user.first_name)
            instance.user.last_name = user_data.get('last_name', instance.user.last_name)
            instance.user.save()

        # Update Patient-specific fields
        instance.address = validated_data.get('address', instance.address)
        instance.date_of_birth = validated_data.get('date_of_birth', instance.date_of_birth)
        # If you need to update caregiver, handle it similarly.
        instance.save()
        return instance
    
# Serializer for HealthInfo
class HealthInfoSerializer(serializers.ModelSerializer):
    class Meta:
        model = HealthInfo
        fields = ['id', 'patient', 'height', 'weight', 'blood_type']
        # You can set patient as read-only if you want to assign it from the view.
        read_only_fields = ['patient']

    def create(self, validated_data):
        # Create and return a new HealthInfo instance
        return HealthInfo.objects.create(**validated_data)

    def update(self, instance, validated_data):
        # Update instance fields with validated data
        instance.height = validated_data.get('height', instance.height)
        instance.weight = validated_data.get('weight', instance.weight)
        instance.blood_type = validated_data.get('blood_type', instance.blood_type)
        instance.save()
        return instance