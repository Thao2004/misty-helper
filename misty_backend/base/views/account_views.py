from django.contrib.auth.models import User
from django.contrib.auth import authenticate
from django.http import HttpResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from base.models import Caregiver, Patient, HealthInfo, Checkup
from base.serializers import (
    CaregiverSerializer,
    PatientSerializer,
    HealthInfoSerializer,
    CheckupSerializer,
)

# ---- Public ----

def index(request):
    return HttpResponse("Hello, world. You're at the base index.")


@api_view(['POST'])
@permission_classes([AllowAny])
def create_caregiver(request):
    serializer = CaregiverSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def create_patient(request):
    serializer = PatientSerializer(data=request.data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request): 
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(request, username=username, password=password)
    if user is not None:
        refresh = RefreshToken.for_user(user)

        role = 'Unknown'
        if Caregiver.objects.filter(user=user).exists():
            role = 'Caregiver'
        elif Patient.objects.filter(user=user).exists():
            role = 'Patient'

        return Response({
            'user_id': user.id,
            'username': user.username,
            'role': role,
            'access': str(refresh.access_token),
            'refresh': str(refresh),
        })
    return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
# @permission_classes([IsAuthenticated])
def logout_view(request):
    return Response({'message': 'Logout successful. Please delete token client-side.'})

# ---- Views using user_id ----

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_health_info(request, user_id):
    try:
        patient = Patient.objects.get(user__id=user_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    try:
        healthinfo = patient.health_info
        serializer = HealthInfoSerializer(healthinfo)
        return Response(serializer.data)
    except HealthInfo.DoesNotExist:
        return Response({'detail': 'Health info not found.'}, status=404)


@api_view(['POST', 'PUT'])
# @permission_classes([IsAuthenticated])
def update_health_info_with_user(request, user_id):
    try:
        patient = Patient.objects.get(user__id=user_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    try:
        healthinfo = patient.health_info
        serializer = HealthInfoSerializer(healthinfo, data=request.data, partial=True)
    except HealthInfo.DoesNotExist:
        data = request.data.copy()
        data['patient'] = patient.id
        serializer = HealthInfoSerializer(data=data)

    if serializer.is_valid():
        serializer.save(patient=patient)
        return Response(serializer.data)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_patient_with_healthinfo(request, user_id):
    try:
        patient = Patient.objects.get(user__id=user_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    patient_data = PatientSerializer(patient).data
    health_data = (
        HealthInfoSerializer(patient.health_info).data
        if hasattr(patient, 'health_info') else None
    )
    return Response({
        "patient": patient_data,
        "health_info": health_data
    })


@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_patient_info(request, user_id):
    try:
        patient = Patient.objects.get(user__id=user_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    serializer = PatientSerializer(patient)
    return Response(serializer.data)


@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_caregiver_info(request, user_id):
    try:
        caregiver = Caregiver.objects.get(user__id=user_id)
    except Caregiver.DoesNotExist:
        return Response({'detail': 'Caregiver not found.'}, status=404)

    serializer = CaregiverSerializer(caregiver)
    return Response(serializer.data)


@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_my_patients(request, user_id):
    try:
        caregiver = Caregiver.objects.get(user__id=user_id)
    except Caregiver.DoesNotExist:
        return Response({'detail': 'Caregiver not found.'}, status=404)

    patients = Patient.objects.filter(caregiver=caregiver)
    serializer = PatientSerializer(patients, many=True)
    return Response(serializer.data)
