from django.contrib.auth.models import User
from django.contrib.auth import authenticate, login, logout
from django.http import HttpResponse, JsonResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken



from base.models import Caregiver, Patient, HealthInfo
from base.serializers import CaregiverSerializer, PatientSerializer, HealthInfoSerializer
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


@api_view(['POST', 'PUT'])
@permission_classes([IsAuthenticated])
def healthinfo_view(request):
    try:
        patient = request.user.patient
    except Patient.DoesNotExist:
        return Response({"detail": "Patient profile not found."}, status=status.HTTP_400_BAD_REQUEST)

    try:
        healthinfo = patient.health_info
    except HealthInfo.DoesNotExist:
        healthinfo = None

    if request.method == 'POST':
        if healthinfo is not None:
            return Response({"detail": "Health info already exists. Use PUT to update."}, status=status.HTTP_400_BAD_REQUEST)
        # Attach the patient from the request to validated_data
        data = request.data.copy()
        data['patient'] = patient.id
        serializer = HealthInfoSerializer(data=data)
        if serializer.is_valid():
            serializer.save()  # Calls create()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    elif request.method == 'PUT':
        if healthinfo is None:
            return Response({"detail": "No existing health info found. Use POST to create."}, status=status.HTTP_400_BAD_REQUEST)
        serializer = HealthInfoSerializer(healthinfo, data=request.data, partial=True)
        if serializer.is_valid():
            serializer.save()  # Calls update()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
