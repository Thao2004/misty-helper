from django.db import models
from django.contrib.auth.models import User

# Create your models here.
class Caregiver(models.Model):
    """
    Stores caregiver information.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    role = models.CharField(max_length=100, default="Caregiver")
    hospital = models.CharField(max_length=255)
    date_of_birth = models.DateField(null=True, blank=True)

    def __str__(self):
        return f"{self.user.get_full_name()} - {self.hospital}"


class Patient(models.Model):
    """
    Stores patient information. Each patient has a caregiver.
    """
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    caregiver = models.ForeignKey(Caregiver, on_delete=models.SET_NULL, null=True, related_name='patients')
    address = models.CharField(max_length=255)
    date_of_birth = models.DateField(null=True, blank=True)

    def __str__(self):
        return self.user.get_full_name()

class HealthInfo(models.Model):
    patient = models.OneToOneField(Patient, on_delete=models.CASCADE, related_name="health_info")
    height = models.FloatField(null=True, blank=True, help_text="Height in centimeters")
    weight = models.FloatField(null=True, blank=True, help_text="Weight in kilograms")
    blood_type = models.CharField(max_length=3, blank=True, null=True)
    # Add additional health fields as needed

    def __str__(self):
        return f"Health info for {self.patient.user.get_full_name()}"
    

class Checkup(models.Model):
    caregiver = models.ForeignKey(Caregiver, on_delete=models.CASCADE, related_name="checkups")
    patient = models.ForeignKey(Patient, on_delete=models.CASCADE, related_name="checkups")
    checkup_time_start = models.DateTimeField(help_text="Earliest allowed checkup time")
    checkup_time_end = models.DateTimeField(help_text="Latest allowed checkup time")
    selected_time = models.DateTimeField(null=True, blank=True, help_text="Patient-selected checkup time")
    questions = models.TextField(
        blank=True,
        help_text="JSON list of questions, e.g. ['How do you feel?', 'Did you sleep well?']"
    )
    measure_temperature = models.BooleanField(default=False)
    status = models.CharField(
        max_length=20,
        choices=[('scheduled', 'Scheduled'), ('in_progress', 'In Progress'), ('completed', 'Completed')],
        default='scheduled'
    )
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"Checkup for {self.patient} scheduled by {self.caregiver}"

class CheckupResponse(models.Model):
    checkup = models.ForeignKey(Checkup, on_delete=models.CASCADE, related_name="responses")
    responses = models.TextField(help_text="JSON object mapping questions to answers")
    temperature = models.FloatField(null=True, blank=True, help_text="Temperature reading if measured")
    responded_at = models.DateTimeField(auto_now_add=True)
    openai_summary = models.TextField(blank=True, null=True, help_text="Optional summary from OpenAI")

    def __str__(self):
        return f"Response for {self.checkup} at {self.responded_at}"