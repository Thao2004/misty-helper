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



@api_view(['POST'])
@permission_classes([AllowAny])
def login_view(request): 
    """
    Login a user and return their details.  
    Expected payload example:
    {
    "username": "montim",
    "password": "secret123"
    }
    """
    username = request.data.get('username')
    password = request.data.get('password')

    

    print(f"Login attempt with username: \"{username}\" and password: \"{password}\"")

    user = authenticate(request, username=username, password=password)
    u = User.objects.get(username=username) if username else None  # Get the user object if authentication was successful
    print(f"User object: {u}")  # Debugging line to check the user object
    print(u.check_password(password))  # Debugging line to check the password hash

    if user is not None:
        login(request, user)

        # Check if user is a caregiver or patient
        try:
            caregiver = Caregiver.objects.get(user=user)
            role = 'Caregiver'
        except Caregiver.DoesNotExist:
            caregiver = None
            try:
                patient = Patient.objects.get(user=user)
                role = 'Patient'
            except Patient.DoesNotExist:
                role = 'Unknown'

        print(f"User role: {role}")  # Debugging line to check the user role

        data = {
            'user_id': user.id,
            'username': user.username,
            'role': role
        }
        return Response(
            data=data, 
            status=status.HTTP_200_OK
        )

    else:
        return JsonResponse({'error': 'Invalid credentials'}, status=status.HTTP_401_UNAUTHORIZED)


@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_view(request):
    logout(request)
    return JsonResponse({'message': 'Logout successful'})

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
