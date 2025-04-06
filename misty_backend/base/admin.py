from django.contrib import admin
from .models import Caregiver, Patient, HealthInfo, Checkup, CheckupResponse

admin.site.register(Caregiver)
admin.site.register(Patient)
admin.site.register(HealthInfo)
admin.site.register(Checkup)
admin.site.register(CheckupResponse)

