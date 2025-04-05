from django.contrib import admin
from .models import Caregiver, Patient, HealthInfo

admin.site.register(Caregiver)
admin.site.register(Patient)
admin.site.register(HealthInfo)
