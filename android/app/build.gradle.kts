plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("dev.flutter.flutter-gradle-plugin")
}

val ciReleaseKeystorePath = System.getenv("CI_RELEASE_KEYSTORE_PATH")
val ciReleaseSigningEnabled = !ciReleaseKeystorePath.isNullOrBlank()

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

    if (ciReleaseSigningEnabled) {
        signingConfigs {
            create("ciRelease") {
                storeFile = file(ciReleaseKeystorePath!!)
                storePassword = System.getenv("CI_RELEASE_STORE_PASSWORD")
                keyAlias = System.getenv("CI_RELEASE_KEY_ALIAS")
                keyPassword = System.getenv("CI_RELEASE_KEY_PASSWORD")
            }
        }
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
            // Production signing must use a real release/upload keystore.
            // CI uses a temporary, non-production keystore only to validate
            // that release APK/AAB packaging works end-to-end.
            if (ciReleaseSigningEnabled) {
                signingConfig = signingConfigs.getByName("ciRelease")
            }
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

flutter {
    source = "../.."
}

// Flutter 3.44.7 may complete the Android assembleRelease task but fail to
// copy the generated APKs into build/app/outputs/flutter-apk. Configure the
// task lazily so the task exists before we attach the sync action.
tasks.configureEach {
    if (name == "assembleRelease") {
        doLast {
            val sourceDir = layout.buildDirectory.dir("outputs/apk/release").get().asFile
            val flutterOutputDir = rootProject.projectDir.parentFile.resolve("build/app/outputs/flutter-apk")
            if (sourceDir.exists()) {
                flutterOutputDir.mkdirs()
                sourceDir.listFiles { file -> file.extension == "apk" }?.forEach { apk ->
                    apk.copyTo(flutterOutputDir.resolve(apk.name), overwrite = true)
                }
                println("[flutter-ci] Synced release APKs to ${flutterOutputDir.absolutePath}")
            }
        }
    }
}
