from rest_framework import serializers
from django.contrib.auth.models import User
from .models import Caregiver, Patient, HealthInfo, Checkup, CheckupResponse

# Serializer for Django's built-in User model.
class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = ['id', 'username', 'first_name', 'last_name', 'email']

# Serializer for Caregiver
class CaregiverSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username')
    password = serializers.CharField(write_only=True, source='user.password')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    email = serializers.EmailField(source='user.email', required=False)

    class Meta:
        model = Caregiver
        fields = [
            'id',
            'username',
            'password',
            'first_name',
            'last_name',
            'email',
            'role',
            'hospital',
            'date_of_birth'
        ]

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        password = user_data.pop('password')
        user = User(**user_data)
        user.set_password(password)
        user.save()
        caregiver = Caregiver.objects.create(user=user, **validated_data)
        return caregiver

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', {})
        user = instance.user

        for attr, value in user_data.items():
            if attr == 'password':
                user.set_password(value)
            else:
                setattr(user, attr, value)
        user.save()

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
        instance.save()
        return instance
    
# Serializer for Patient
class PatientSerializer(serializers.ModelSerializer):
    username = serializers.CharField(source='user.username')
    password = serializers.CharField(write_only=True, source='user.password')
    first_name = serializers.CharField(source='user.first_name')
    last_name = serializers.CharField(source='user.last_name')
    email = serializers.EmailField(source='user.email', required=False)

    class Meta:
        model = Patient
        fields = [
            'id',
            'username',
            'password',
            'first_name',
            'last_name',
            'email',
            'caregiver',
            'address',
            'date_of_birth'
        ]

    def create(self, validated_data):
        user_data = validated_data.pop('user')
        password = user_data.pop('password')
        user = User(**user_data)
        user.set_password(password)
        user.save()
        patient = Patient.objects.create(user=user, **validated_data)
        return patient

    def update(self, instance, validated_data):
        user_data = validated_data.pop('user', {})
        user = instance.user

        for attr, value in user_data.items():
            if attr == 'password':
                user.set_password(value)
            else:
                setattr(user, attr, value)
        user.save()

        for attr, value in validated_data.items():
            setattr(instance, attr, value)
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

class CheckupSerializer(serializers.ModelSerializer):
    caregiver = serializers.PrimaryKeyRelatedField(read_only=True)
    patient = serializers.PrimaryKeyRelatedField(read_only=True)
    
    class Meta:
        model = Checkup
        fields = [
            'id',
            'caregiver',
            'patient',
            'checkup_time_start',
            'checkup_time_end',
            'selected_time',
            'questions',
            'measure_temperature',
            'status',
            'created_at',
        ]
        read_only_fields = ['status', 'created_at']

    def create(self, validated_data):
        # The caregiver and patient should be set from the view context
        return Checkup.objects.create(**validated_data)

class CheckupResponseSerializer(serializers.ModelSerializer):
    checkup = serializers.PrimaryKeyRelatedField(queryset=Checkup.objects.all())
    
    class Meta:
        model = CheckupResponse
        fields = [
            'id',
            'checkup',
            'responses',
            'temperature',
            'responded_at',
            'openai_summary'
        ]
        read_only_fields = ['responded_at', 'openai_summary']
