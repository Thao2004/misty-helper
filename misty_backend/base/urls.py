# base/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from base.views.account_views import (
    index,
    create_caregiver,
    create_patient,
    login_view,
    logout_view,
    get_caregiver_info,
    get_patient_info,
    get_patient_with_healthinfo,
    get_my_patients,
    get_health_info,
    update_health_info_with_user
)
from base.views.checkup_views import (
    create_checkup,
    select_checkup_time,
    get_due_checkups,
    submit_checkup_response,
    get_checkup_history
)

from rest_framework_simplejwt.views import (
    TokenObtainPairView,
    TokenRefreshView,
)

urlpatterns = [
    path('', index, name='index'),  # This is the index view for the base app
    path('register/caregiver/', create_caregiver, name='create_caregiver'),
    path('register/patient/', create_patient, name='create_patient'),
    
    # Authentication endpoints
    path('login/', login_view, name='login'),
    path('logout/', logout_view, name='logout'),

     # JWT endpoints from SimpleJWT
    path('api/token/', TokenObtainPairView.as_view(), name='token_obtain_pair'),  # login
    path('api/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),  # refresh token

    #Info
    # Patients
    path('patients/<int:user_id>/', get_patient_info),
    path('patients/<int:user_id>/healthinfo/', get_health_info, name='get_health_info'),
    path('patients/<int:user_id>/healthinfo/update/', update_health_info_with_user, name='update_health_info_with_user'),
    path('patients/<int:user_id>/with-health/', get_patient_with_healthinfo),

    #Caregiver
    path('caregivers/<int:user_id>/', get_caregiver_info),
    path('caregivers/<int:user_id>/patients/', get_my_patients),

    #Checkups
    path('patients/<int:user_id>/checkups/', get_checkup_history, name='get_checkup_history'),
    path('checkup/', create_checkup, name='create_checkup'),             # POST
    path('checkup/select-time/', select_checkup_time, name='select_checkup_time'),  # POST
    path('checkup/due/<int:user_id>/', get_due_checkups, name='get_due_checkups'),        # GET
    path('checkup/response/', submit_checkup_response, name='submit_checkup_response'),  # POST
]
