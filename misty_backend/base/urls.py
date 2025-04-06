# base/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from base.views.account_views import (
    index,
    create_caregiver,
    create_patient,
    login_view,
    logout_view,
    healthinfo_view
)
from base.views.checkup_views import (
    create_checkup,
    select_checkup_time,
    get_due_checkups,
    submit_checkup_response
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
    
    # Health info endpoints for patients
    path('healthinfo/', healthinfo_view, name='healthinfo'),
    path('checkup/', create_checkup, name='create_checkup'),             # POST
    path('checkup/select-time/', select_checkup_time, name='select_checkup_time'),  # POST
    path('checkup/due/', get_due_checkups, name='get_due_checkups'),        # GET
    path('checkup/response/', submit_checkup_response, name='submit_checkup_response'),  # POST
]
