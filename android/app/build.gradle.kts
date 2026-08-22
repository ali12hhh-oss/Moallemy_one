plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.daleel.child"
    compileSdk = 36
    ndkVersion = "28.2.13676358"

    defaultConfig {
        applicationId = "com.daleel.child"
        minSdk = 24
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = "17"
    }

    buildTypes {
        release {
            isMinifyEnabled = false
            isShrinkResources = false
        }
        debug {
            applicationIdSuffix = ".debug"
            versionNameSuffix = "-debug"
        }
    }

    packaging {
        resources {
            excludes += "/META-INF/{AL2.0,LGPL2.1}"
        }
    }
}

// Flutter 3.44.x can build the APK successfully with the modern AGP Plugin DSL,
// but fail to discover the artifact because it expects it in the Flutter output
// directory. Keep the Android build unchanged and explicitly sync the generated
// APK/AAB to Flutter's expected output directories after the corresponding task.
val syncFlutterReleaseApks = tasks.register<Copy>("syncFlutterReleaseApks") {
    from(layout.buildDirectory.dir("outputs/apk/release")) {
        include("*.apk")
    }
    into(rootProject.layout.projectDirectory.dir("../build/app/outputs/flutter-apk"))
}

tasks.matching { it.name == "assembleRelease" }.configureEach {
    finalizedBy(syncFlutterReleaseApks)
}

val syncFlutterReleaseAab = tasks.register<Copy>("syncFlutterReleaseAab") {
    from(layout.buildDirectory.dir("outputs/bundle/release")) {
        include("*.aab")
    }
    into(rootProject.layout.projectDirectory.dir("../build/app/outputs/bundle/release"))
}

tasks.matching { it.name == "bundleRelease" }.configureEach {
    finalizedBy(syncFlutterReleaseAab)
}

flutter {
    source = "../.."
}
