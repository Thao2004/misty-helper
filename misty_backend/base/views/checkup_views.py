from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone
from base.serializers import CheckupSerializer, CheckupResponseSerializer
from base.models import Patient, Caregiver, Checkup

# -------- Create checkup using user_id -------- #

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_checkup(request):
    """
    Create a new checkup using caregiver and patient user IDs.

    Payload:
    {
        "caregiver_user": 2,
        "patient_user": 5,
        "checkup_time_start": "...",
        "checkup_time_end": "...",
        "questions": "[\"Q1\", \"Q2\"]",
        "measure_temperature": true
    }
    """
    try:
        caregiver = Caregiver.objects.get(user__id=request.data.get('caregiver_user'))
        patient = Patient.objects.get(user__id=request.data.get('patient_user'))
    except (Caregiver.DoesNotExist, Patient.DoesNotExist):
        return Response({"detail": "Caregiver or patient not found."}, status=404)

    data = request.data.copy()
    data['caregiver'] = caregiver.id
    data['patient'] = patient.id

    serializer = CheckupSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# -------- Select checkup time (unchanged logic) -------- #

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def select_checkup_time(request):
    """
    Set the selected time for a checkup.

    Payload:
    {
        "checkup_id": <id>,
        "selected_time": "..."
    }
    """
    checkup_id = request.data.get("checkup_id")
    selected_time = request.data.get("selected_time")

    try:
        checkup = Checkup.objects.get(id=checkup_id)
    except Checkup.DoesNotExist:
        return Response({"detail": "Checkup not found."}, status=404)

    checkup.selected_time = selected_time
    checkup.save()

    serializer = CheckupSerializer(checkup)
    return Response(serializer.data)

# -------- Get due checkups for a user (patient) -------- #

@api_view(['GET'])
@permission_classes([AllowAny])  # Misty or device
def get_due_checkups(request, user_id):
    """
    Return checkups due within ±5 minutes for a patient user ID.
    """
    try:
        patient = Patient.objects.get(user__id=user_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    now = timezone.now()
    window_start = now - timezone.timedelta(minutes=5)
    window_end = now + timezone.timedelta(minutes=5)

    checkups = Checkup.objects.filter(
        patient=patient,
        selected_time__gte=window_start,
        selected_time__lte=window_end,
        status='scheduled'
    )

    serializer = CheckupSerializer(checkups, many=True)
    return Response(serializer.data)

# -------- Submit checkup response (Misty) -------- #

@api_view(['POST'])
@permission_classes([AllowAny])
def submit_checkup_response(request):
    """
    Submit checkup response data from Misty.
    
    Payload:
    {
        "checkup": <checkup_id>,
        "responses": "{\"Q1\": \"Yes\", \"Q2\": \"No\"}",
        "temperature": 36.7
    }
    """
    serializer = CheckupResponseSerializer(data=request.data)
    if serializer.is_valid():
        response_obj = serializer.save()
        checkup = response_obj.checkup
        checkup.status = 'completed'
        checkup.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

# -------- Get checkup history for patient (by user_id) -------- #

@api_view(['GET'])
# @permission_classes([IsAuthenticated])
def get_checkup_history(request, user_id):
    """
    Return all checkups for a patient by user ID.
    """
    try:
        patient = Patient.objects.get(user__id=user_id)
    except Patient.DoesNotExist:
        return Response({'detail': 'Patient not found.'}, status=404)

    checkups = Checkup.objects.filter(patient=patient).order_by('-created_at')
    serializer = CheckupSerializer(checkups, many=True)
    return Response(serializer.data)
