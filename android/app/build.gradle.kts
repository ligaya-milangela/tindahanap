plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase Plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Plugin
}

android {
    namespace = "com.example.tindahanap"
    compileSdk = 35  // Use an explicit version
    ndkVersion = "27.0.12077973"  // Update to your required version

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.tindahanap"
        minSdk = 23  // Explicit version
        targetSdk = 35  // Explicit version
        versionCode = 1
        versionName = "1.0"
    }

    buildTypes {
    release {
        isMinifyEnabled = true  // Enable minification
        isShrinkResources = true  // Keep resource shrinking enabled
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
    }
}


}

flutter {
    source = "../.."
}
