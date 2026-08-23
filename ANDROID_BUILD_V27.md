# إعداد Android

تم تضمين مجلد Android فعلي داخل المشروع.

- Application ID: `com.daleel.child`
- App label: `معلمي`
- minSdk: 24
- compileSdk: 36
- targetSdk: قيمة Flutter الحالية
- Java/Kotlin JVM: 17
- Android Gradle Plugin (AGP): 8.11.1
- Kotlin plugin: 2.2.20
- Gradle wrapper: 8.14
- NDK: 28.2.13676358
- ABI: إعداد Android الافتراضي للمشروع
- AndroidX + Jetifier
- TTS service query مضاف لـflutter_tts
- RTL: `supportsRtl=true`
- Cleartext HTTP disabled
- Release APK يتم بناؤه في GitHub Actions باستخدام Gradle مباشرة.

## مسار APK في CI

يتم بناء الإصدار بواسطة:

```text
android/gradlew app:assembleRelease
```

ثم يكون الناتج المتوقع في:

```text
android/app/build/outputs/apk/release/app-release.apk
```

ويتم نسخه إلى المسار القياسي الذي يستخدمه Artifact:

```text
build/app/outputs/flutter-apk/app-release.apk
```

تم اعتماد البناء المباشر بواسطة Gradle في GitHub Actions لأن إعداد Android الحالي يستخدم Android Gradle Plugin عبر Plugin DSL، وفي بعض إصدارات Flutter قد ينجح `assembleRelease` بينما يفشل Flutter CLI في اكتشاف ملف APK الناتج.

## التوقيع

إصدار CI الحالي يستخدم Debug signing حتى يكون APK قابلاً للتثبيت والاختبار. لا توجد مفاتيح توقيع Release داخل المستودع. إصدار Google Play النهائي يجب أن يستخدم مفتاح توقيع/رفع خاصاً محفوظاً خارج GitHub source، ويفضل تخزين بياناته في GitHub Secrets.
