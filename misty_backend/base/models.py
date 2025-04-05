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