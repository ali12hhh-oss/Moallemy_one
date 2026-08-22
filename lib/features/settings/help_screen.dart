import 'package:flutter/material.dart';

/// A simple, fully offline "how to use the app" guide for parents,
/// reachable from Settings. Purely additive — does not change or
/// remove any existing screen or feature.
class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(title: const Text('تعليمات الاستخدام')),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: const [
              Card(
                child: Padding(
                  padding: EdgeInsets.all(18),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 27,
                        child: Text('📖', style: TextStyle(fontSize: 24)),
                      ),
                      SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          'دليل سريع لاستخدام التطبيق مع طفلك',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _Step(
                number: '١',
                icon: Icons.person_add_alt_1_rounded,
                title: 'أضف ملف طفلك',
                body:
                    'من الشاشة الرئيسية اختر "ملفات الأطفال"، ثم أضف اسم الطفل '
                    'وعمره. يساعد هذا التطبيق على اقتراح المحتوى المناسب لمرحلته.',
              ),
              _Step(
                number: '٢',
                icon: Icons.menu_book_rounded,
                title: 'ابدأ بالمنهج الكامل',
                body:
                    'بطاقتا "اللغة العربية — المنهج الكامل" و"الرياضيات — المنهج '
                    'الكامل" في أعلى الشاشة الرئيسية هما أفضل نقطة بداية، فهما '
                    'مرتّبتان خطوة بخطوة حسب مستوى الطفل.',
              ),
              _Step(
                number: '٣',
                icon: Icons.volume_up_rounded,
                title: 'استمع إلى صوت الحرف',
                body:
                    'داخل شاشات الحروف، اضغط زر "استمع إلى صوت الحرف" لسماع النطق '
                    'الصحيح — يعمل هذا بدون اتصال بالإنترنت، ويمكن تكراره بلا حدود.',
              ),
              _Step(
                number: '٤',
                icon: Icons.psychology_alt_rounded,
                title: 'مهمتك الذكية',
                body:
                    'تظهر في أعلى الشاشة الرئيسية بطاقة "مهمتك الذكية" تقترح على '
                    'الطفل نشاطًا مناسبًا تلقائيًا بناءً على تقدّمه.',
              ),
              _Step(
                number: '٥',
                icon: Icons.videogame_asset_rounded,
                title: 'العب واربح',
                body:
                    'بعد إنهاء بعض الدروس، شجّع طفلك على تجربة "الألعاب التعليمية" '
                    'و"الاختبارات" لكسب نجوم، ثم استبدالها من "متجر النجوم".',
              ),
              _Step(
                number: '٦',
                icon: Icons.family_restroom_rounded,
                title: 'تابع تقدّم طفلك',
                body: 'من "لوحة الوالدين" يمكنك متابعة الدروس المكتملة، دقة '
                    'الاختبارات، وقت التعلّم، ونقاط الضعف المقترح مراجعتها.',
              ),
              _Step(
                number: '٧',
                icon: Icons.settings_rounded,
                title: 'خصّص التجربة',
                body: 'من "الإعدادات" يمكنك تفعيل الوضع الليلي، ضبط مدة جلسة '
                    'التعلّم اليومية، وتشغيل أو إيقاف الأصوات والمؤثرات.',
              ),
              _Step(
                number: '٨',
                icon: Icons.wifi_off_rounded,
                title: 'يعمل دون إنترنت',
                body:
                    'كل محتوى التطبيق وتقدّم طفلك محفوظ على الجهاز مباشرة، فيمكن '
                    'استخدام التطبيق بالكامل في أي مكان بدون اتصال بالإنترنت.',
              ),
            ],
          ),
        ),
      );
}

class _Step extends StatelessWidget {
  final String number;
  final IconData icon;
  final String title;
  final String body;
  const _Step({
    required this.number,
    required this.icon,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                child: Text(
                  number,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          icon,
                          size: 20,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(body,
                        style: const TextStyle(fontSize: 14.5, height: 1.6)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
