# ****Tindahanap****

# Setting Up Environments (Backend & Fronted)
# Prerequisites

Make sure you have the following installed:

- **Python 3.x**
- **Flutter** (with dart)
- **pip** (Python package installer)

## Getting Started

### 1. Clone the Repository

```bash
git clone <repository-url>
cd <repository-name>
```

### 2. Set Up Django Backend
-Install Django
```bash
pip install django djangorestframework djangorestframework-simplejwt django-cors-headers
django-admin startproject back #you can change the name back, if you want
cd back
django-admin startapp stores #you can change the name store, if you want
```
-Configute settings.py, Add the necessary installed apps:

```bash
'rest_framework',
'corsheaders',
'stores'
```


- Enable CORS to allow Flutter to access the API:
  ```bash
  	MIDDLEWARE = [
    		'corsheaders.middleware.CorsMiddleware',
    		'django.middleware.security.SecurityMiddleware',
    		'django.contrib.sessions.middleware.SessionMiddleware',
    		'django.middleware.common.CommonMiddleware',
			'django.middleware.csrf.CsrfViewMiddleware',
    		'django.contrib.auth.middleware.AuthenticationMiddleware',
    		'django.contrib.messages.middleware.MessageMiddleware',
    		'django.middleware.clickjacking.XFrameOptionsMiddleware',]
	CORS_ALLOW_ALL_ORIGINS = True

- Enable JWT Authentication:

  ```bash
  REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ), }
  ```

- Run Migrations and Start Server
```bash
python manage.py migrate
python manage.py runserver
```


### 3. Set Up Flutter
- Install Flutter https://flutter.dev/docs/get-started/install

```bash
  flutter --version
```

- Create a New Flutter Project

```bash
flutter create tindahanap
cd tindahanap
```

- Install Dependencies. Ensure pubspec.yaml includes these dependencies:

```bash
dependencies:
  flutter:
    sdk: flutter
  dio: ^5.3.2
  shared_preferences: ^2.2.0
  google_maps_flutter: ^2.5.0
```

- Run ```bash flutter pub get ```

- Run Flutter App on a Device.

```bash
flutter devices  # Check if the device is detected
flutter run      # Run the app on the connected device
```

### 4. Git Commands for Pushing Updates

- Initialize Git. If Git is not set up yet: ```bash git init ```
 	- Link to GitHub Repository. ```bash git remote add origin https://github.com/your-username/tindahanap.git```
    - Verify ```bash git remote -v ```
- Create a Branch for Your Task
  	- Before making changes, create a new branch:
 
  	```bash
   	git checkout -b feature-branch-name
   ```
- Add & Commit Changes

  ```bash
  	git add .
  	git commit -m "Updated features"
  ```

- Push to Github
  	- Push the changes to the newly created branch
 
  	  ```bash
  	  	git push origin branch_name
  	  ```


### 5. Git Commands for Pulling Updates

- Pull updates from Github

  ```bash
  	git checkout main
  	git pull origin main
  ```
  
