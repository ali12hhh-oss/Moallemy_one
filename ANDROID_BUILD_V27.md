# إعداد Android V27

تم تضمين مجلد Android فعلي داخل المشروع.

- Application ID: `com.daleel.child`
- App label: `دليل الطفل`
- minSdk: 21 (يدعم Android 5.0+، وهو الحد الأدنى الحالي لـFlutter)
- Java/Kotlin JVM: 17
- AGP: 8.13.2
- Kotlin plugin: 2.2.21
- Gradle wrapper: 8.13
- ABI: armeabi-v7a / arm64-v8a / x86_64
- AndroidX + Jetifier
- TTS service query مضاف لـflutter_tts
- RTL: `supportsRtl=true`
- Cleartext HTTP disabled
- Release APK/AAB build في GitHub Actions
- أيقونة Android فعلية مولدة محلياً بأحجام mdpi إلى xxxhdpi + adaptive icon.

ملاحظة: لا توجد مفاتيح توقيع Release داخل المستودع. توقيع Play Store يجب أن يتم بمفتاح خاص خارج GitHub source.
