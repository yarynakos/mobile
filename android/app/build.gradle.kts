plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.my_project"
    compileSdk = 33
    ndkVersion = "27.0.12077973"

    defaultConfig {
        applicationId = "com.example.my_project"
        minSdk = 21
        targetSdk = 33
        versionCode = 1
        versionName = "1.0"

        // 🔥 ОБОВʼЯЗКОВО!
        multiDexEnabled = true
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "17"
    }
}

flutter {
    source = "../.."
}

dependencies {
    // 🔥 Без цього — core desugaring не працюватиме
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.4")

    // 🔥 Для multidex підтримки
    implementation("androidx.multidex:multidex:2.0.1")
}
