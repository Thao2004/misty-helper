from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.response import Response
from rest_framework import status
from django.utils import timezone
from base.serializers import CheckupSerializer, CheckupResponseSerializer
from base.models import Patient, Caregiver, Checkup  # and CheckupResponse if needed

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def create_checkup(request):
    """
    Caregiver creates a new checkup.
    Expected payload example:
    {
        "patient": <patient_id>,
        "checkup_time_start": "2025-04-05T16:00:00Z",
        "checkup_time_end": "2025-04-05T18:00:00Z",
        "questions": "[\"How do you feel?\", \"Did you sleep well?\"]",
        "measure_temperature": true
    }
    The caregiver field is set automatically from the logged-in caregiver.
    """
    try:
        caregiver = request.user.caregiver
    except Exception:
        return Response({"detail": "User is not a caregiver."}, status=status.HTTP_403_FORBIDDEN)
    
    data = request.data.copy()
    data['caregiver'] = caregiver.id  # set caregiver from the logged-in user

    serializer = CheckupSerializer(data=data)
    if serializer.is_valid():
        serializer.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def select_checkup_time(request):
    """
    Patient selects a preferred time for an existing checkup.
    Expected payload:
    {
        "checkup_id": <id>,
        "selected_time": "2025-04-05T17:00:00Z"
    }
    """
    try:
        patient = request.user.patient
    except Exception:
        return Response({"detail": "User is not a patient."}, status=status.HTTP_403_FORBIDDEN)

    checkup_id = request.data.get("checkup_id")
    selected_time = request.data.get("selected_time")
    try:
        checkup = Checkup.objects.get(id=checkup_id, patient=patient)
    except Checkup.DoesNotExist:
        return Response({"detail": "Checkup not found for this patient."}, status=status.HTTP_404_NOT_FOUND)
    
    checkup.selected_time = selected_time
    checkup.save()
    serializer = CheckupSerializer(checkup)
    return Response(serializer.data)

@api_view(['GET'])
@permission_classes([AllowAny])
def get_due_checkups(request):
    """
    Misty polls to get checkups that are due to be performed.
    This endpoint returns checkups that have a selected_time in the past few minutes.
    """
    now = timezone.now()
    window_start = now - timezone.timedelta(minutes=5)
    window_end = now + timezone.timedelta(minutes=5)
    checkups = Checkup.objects.filter(
        selected_time__gte=window_start,
        selected_time__lte=window_end,
        status='scheduled'
    )
    serializer = CheckupSerializer(checkups, many=True)
    return Response(serializer.data)

@api_view(['POST'])
@permission_classes([AllowAny])
def submit_checkup_response(request):
    """
    Misty sends responses for a checkup.
    Expected payload:
    {
        "checkup": <checkup_id>,
        "responses": "{\"How do you feel?\": \"I feel fine.\", \"Did you sleep well?\": \"Yes.\"}",
        "temperature": 36.7
    }
    Optionally, you could later trigger OpenAI to process the responses.
    """
    serializer = CheckupResponseSerializer(data=request.data)
    if serializer.is_valid():
        response_obj = serializer.save()
        # Update the checkup status to completed
        checkup = response_obj.checkup
        checkup.status = 'completed'
        checkup.save()
        return Response(serializer.data, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
