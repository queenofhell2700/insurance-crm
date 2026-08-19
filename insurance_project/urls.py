from django import views
from django.contrib import admin
from django.urls import path, include
from django.contrib.auth import views as auth_views
# CHANGED: import CustomLoginView instead of login_view
from advisors.views import signup_view, CustomLoginView, dashboard

#added new
from advisors.views import current_user_api, add_customer_policy_api

urlpatterns = [
    path("admin/", admin.site.urls),

    # Auth routes (custom Django views)
    # CHANGED: use CustomLoginView.as_view() instead of login_view
    path("login/", CustomLoginView.as_view(), name="login"),
    path("logout/", auth_views.LogoutView.as_view(next_page="login"), name="logout"),

    # Dashboard and signup (session-based auth)
    path("dashboard/", dashboard, name="dashboard"),
    path("signup/", signup_view, name="signup"),

    # API routes
    path("", include("advisors.urls")),

    #added new
    path('api/user/profile/', current_user_api, name='current_user_api'),
    path('api/policies/add/', add_customer_policy_api, name='add_customer_policy_api'),
]