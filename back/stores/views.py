from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status
from rest_framework_simplejwt.tokens import RefreshToken
from django.contrib.auth import authenticate
from .serializers import UserSerializer

class SignupView(APIView):
    def post(self, request):
        print("Received signup request:", request.data)  # test line
        serializer = UserSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            print("User created:", serializer.data)  # test line
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        print("Signup error:", serializer.errors)  # test line
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class LoginView(APIView):
    def post(self, request):
        print("Received login request:", request.data)  # test line
        username = request.data.get("username")
        password = request.data.get("password")
        user = authenticate(username=username, password=password)
        if user is not None:
            refresh = RefreshToken.for_user(user)
            print("Login successful for:", username)  # test line
            return Response({
                "refresh": str(refresh),
                "access": str(refresh.access_token)
            })
        print("Login failed for:", username)  # test line
        return Response({"error": "Invalid credentials"}, status=status.HTTP_401_UNAUTHORIZED)
