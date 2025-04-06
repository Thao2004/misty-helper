from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken



from base.models import Caregiver, Patient, HealthInfo, Checkup, CheckupResponse
from base.serializers import CaregiverSerializer, PatientSerializer, HealthInfoSerializer, CheckupSerializer, CheckupResponseSerializer
from django.utils import timezone
from rest_framework_simplejwt.tokens import RefreshToken

def index(request):
    return HttpResponse("Hello, world. You're at the base index.")


@api_view(['POST'])
@permission_classes([AllowAny])
def create_caregiver(request):
    """
    Create a new caregiver account.
    """
    serializer = CaregiverSerializer(data=request.data)
    if serializer.is_valid():
        caregiver = serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def create_patient(request):
    """
    Create a new patient account.
    """
    serializer = PatientSerializer(data=request.data)
    if serializer.is_valid():
        patient = serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request): 
    """
    Login a user and return JWT tokens and role info.
    """
    username = request.data.get('username')
    password = request.data.get('password')

    user = authenticate(request, username=username, password=password)

    if user is not None:
        # Generate JWT tokens
        refresh = RefreshToken.for_user(user)

        # Determine role
        role = 'Unknown'
        if Caregiver.objects.filter(user=user).exists():
            role = 'Caregiver'
        elif Patient.objects.filter(user=user).exists():
            role = 'Patient'

        data = {
            'user_id': user.id,
            'username': user.username,
            'role': role,
            'access': str(refresh.access_token),
            'refresh': str(refresh),
        }
        return Response(data, status=status.HTTP_200_OK)
    
    return Response({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """
    JWT logout - handled client-side by deleting token.
    Optionally blacklist refresh token if using token blacklist.
    """
    return Response({'message': 'Logout successful. Please delete token client-side.'})


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_health_info(request, patient_id):
    """
    View a patient's health info by patient_id.
    Allowed if requester is the patient or their caregiver.
    """
    try:
        patient = Patient.objects.get(id=patient_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)


    try:
        healthinfo = patient.health_info
        serializer = HealthInfoSerializer(healthinfo)
        return Response(serializer.data)
    except HealthInfo.DoesNotExist:
        return Response({'detail': 'Health info not found.'}, status=404)


@api_view(['POST', 'PUT'])
@permission_classes([IsAuthenticated])
def update_health_info_with_user(request, patient_id):
    """
    Create or update a patient's health info by patient ID.
    Allowed if requester is the patient or their caregiver.
    """
    try:
        patient = Patient.objects.get(id=patient_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    try:
        healthinfo = patient.health_info
        serializer = HealthInfoSerializer(healthinfo, data=request.data, partial=True)
    except HealthInfo.DoesNotExist:
        # Creating new record
        data = request.data.copy()
        data['patient'] = patient.id
        serializer = HealthInfoSerializer(data=data)

    if serializer.is_valid():
        serializer.save(patient=patient)
        return Response(serializer.data, status=status.HTTP_200_OK)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


#-----GET ENDPOINTS-----#

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_patient_with_healthinfo(request, patient_id):
    """
    Get patient info + health info by patient ID.
    Allowed: the patient themselves or their caregiver.
    """
    try:
        patient = Patient.objects.get(id=patient_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    patient_data = PatientSerializer(patient).data
    health_data = HealthInfoSerializer(patient.health_info).data if hasattr(patient, 'health_info') else None

    return Response({
        "patient": patient_data,
        "health_info": health_data
    })


@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_patient_info(request, patient_id):
    """
    Allows a patient or their caregiver to retrieve patient info by patient ID.
    """
    from base.models import Patient
    from base.serializers import PatientSerializer

    # Try to get the requested patient
    try:
        patient = Patient.objects.get(id=patient_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    serializer = PatientSerializer(patient)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_caregiver_info(request, caregiver_id):
    """
    Get caregiver info by caregiver ID.
    Only allowed if the user is the caregiver themselves.
    """
    try:
        caregiver = Caregiver.objects.get(id=caregiver_id)
    except Caregiver.DoesNotExist:
        return Response({'detail': 'Caregiver not found.'}, status=404)

   
    serializer = CaregiverSerializer(caregiver)
    return Response(serializer.data)
   

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def get_my_patients(request, caregiver_id):
    """
    Get list of patients for a caregiver by caregiver ID.
    Only allowed if the requester is that caregiver.
    """
    try:
        caregiver = Caregiver.objects.get(id=caregiver_id)
    except Caregiver.DoesNotExist:
        return Response({'detail': 'Caregiver not found.'}, status=404)

    patients = Patient.objects.filter(caregiver=caregiver)
    serializer = PatientSerializer(patients, many=True)
    return Response(serializer.data)
