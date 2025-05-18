import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("com.google.gms.google-services") // Firebase Plugin
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin") // Flutter Plugin
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(FileInputStream(keystorePropertiesFile))
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

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties["keyAlias"] as String
            keyPassword = keystoreProperties["keyPassword"] as String
            storeFile = keystoreProperties["storeFile"]?.let { file(it) }
            storePassword = keystoreProperties["storePassword"] as String
        }
    }

    buildTypes {
    release {
        isMinifyEnabled = true  // Enable minification
        isShrinkResources = true  // Keep resource shrinking enabled
        proguardFiles(getDefaultProguardFile("proguard-android-optimize.txt"), "proguard-rules.pro")
        signingConfig = signingConfigs.getByName("release")
    }
}


}

flutter {
    source = "../.."
}
