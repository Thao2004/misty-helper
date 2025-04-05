# base/urls.py

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from views import base_views as viewss
from base.views.account_views import (
    index,
    create_caregiver,
    create_patient,
    CustomLoginView,
    logout_view,
    healthinfo_view
)
urlpatterns = [
    path('', index, name='index'),  # This is the index view for the base app
    path('register/caregiver/', create_caregiver, name='create_caregiver'),
    path('register/patient/', create_patient, name='create_patient'),
    
    # Authentication endpoints
    path('login/', CustomLoginView.as_view(), name='login'),
    path('logout/', logout_view, name='logout'),
    
    # Health info endpoints for patients
    path('healthinfo/', healthinfo_view, name='healthinfo'),
]
