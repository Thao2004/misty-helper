from django.contrib.auth.models import User
from django.http import HttpResponse
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from rest_framework import status
from rest_framework.authtoken.models import Token
from rest_framework.authtoken.views import ObtainAuthToken

from base.models import Caregiver, Patient, HealthInfo
from base.serializers import CaregiverSerializer, PatientSerializer, HealthInfoSerializer

def index(request):
    return HttpResponse("Hello, world. You're at the base index.")

@api_view(['POST'])
@permission_classes([AllowAny])
def create_caregiver(request):
    """
    Create a new caregiver account.
    Expected payload example:
    {
      "username": "caregiver1",
      "first_name": "Alice",
      "last_name": "Smith",
      "email": "alice@example.com",
      "password": "secret123",
      "hospital": "General Hospital",
      "date_of_birth": "1970-01-01"
    }
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
    Expected payload example:
    {
      "username": "patient1",
      "first_name": "Bob",
      "last_name": "Jones",
      "email": "bob@example.com",
      "password": "secret123",
      "address": "123 Main St",
      "date_of_birth": "1980-05-15",
      "caregiver": <caregiver_id>   // optional if linking via PK or you can handle assignment separately
    }
    """
    serializer = PatientSerializer(data=request.data)
    if serializer.is_valid():
        patient = serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class CustomLoginView(ObtainAuthToken):
    """
    Custom login view that returns a token.
    """
    def post(self, request, *args, **kwargs):
        serializer = self.serializer_class(data=request.data, context={'request': request})
        serializer.is_valid(raise_exception=True)
        user = serializer.validated_data['user']
        token, created = Token.objects.get_or_create(user=user)
        return Response({
            'token': token.key,
            'user_id': user.pk,
        })


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    """
    Log out the current user by deleting their auth token.
    """
    try:
        token = Token.objects.get(user=request.user)
        token.delete()
        return Response({"detail": "Logged out successfully."}, status=status.HTTP_200_OK)
    except Token.DoesNotExist:
        return Response({"detail": "Token not found."}, status=status.HTTP_400_BAD_REQUEST)


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
