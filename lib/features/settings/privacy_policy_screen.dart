import 'package:flutter/material.dart';

/// Shows the app's privacy policy inside the app itself, fully offline.
/// Content mirrors PRIVACY_POLICY_AR.md at the project root, which is the
/// version meant to be published on a public web page (Google Play
/// requires a live URL for apps aimed at children — this in-app screen
/// alone is not a substitute for that, but it keeps the same information
/// always available to parents without needing an internet connection).
class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) => Directionality(
    textDirection: TextDirection.rtl,
    child: Scaffold(
      appBar: AppBar(title: const Text('سياسة الخصوصية')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: const [
          _Section(
            icon: Icons.privacy_tip_rounded,
            title: 'ملخص سريع',
            body:
                '• يعمل التطبيق بالكامل دون اتصال بالإنترنت.\n'
                '• لا نجمع أي بيانات شخصية تُرسَل إلى أي خادم أو طرف خارجي.\n'
                '• لا يوجد إعلانات ولا أدوات تتبّع أو تحليلات من أي طرف ثالث.\n'
                '• لا تُشارَك أي بيانات مع أي جهة على الإطلاق.',
          ),
          _Section(
            icon: Icons.storage_rounded,
            title: 'ما الذي يُخزَّن، وأين؟',
            body:
                'اسم الطفل وعمره التقريبي (اختياري، لتخصيص المرحلة الدراسية)، '
                'وتقدّم التعلّم، والنجوم ونقاط الخبرة، وإعدادات التطبيق — '
                'كل ذلك يُحفظ محليًا فقط على جهاز طفلك، ولا يغادر الجهاز أبدًا.',
          ),
          _Section(
            icon: Icons.volume_up_rounded,
            title: 'الصوت والنطق',
            body:
                'نطق الحروف والكلمات يتم إما عبر ملفات صوت مضمّنة داخل التطبيق، '
                'أو عبر خدمة تحويل النص إلى كلام المدمجة في نظام أندرويد على '
                'جهازك. كلتا الطريقتين تعملان محليًا دون اتصال بالإنترنت.',
          ),
          _Section(
            icon: Icons.block_rounded,
            title: 'الصلاحيات',
            body:
                'لا يطلب التطبيق أي صلاحية وصول إلى الإنترنت أو الكاميرا أو '
                'الموقع الجغرافي أو جهات الاتصال أو الميكروفون.',
          ),
          _Section(
            icon: Icons.child_care_rounded,
            title: 'خصوصية الأطفال',
            body:
                'هذا التطبيق موجّه للأطفال، ولا نجمع أي بيانات تعريف شخصية '
                'للطفل بخلاف ما يُدخله الوالد محليًا داخل الجهاز لتخصيص '
                'تجربة التعلّم فقط.',
          ),
          _Section(
            icon: Icons.delete_outline_rounded,
            title: 'حذف البيانات',
            body:
                'يمكن لولي الأمر حذف جميع البيانات في أي وقت من خلال مسح '
                'بيانات التطبيق من إعدادات النظام، أو إلغاء تثبيت التطبيق.',
          ),
          SizedBox(height: 8),
          Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'للنسخة الكاملة من سياسة الخصوصية أو لأي استفسار، يُرجى مراجعة '
                'الصفحة المنشورة على موقع المطوّر.',
                style: TextStyle(fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Section extends StatelessWidget {
  final IconData icon;
  final String title;
  final String body;
  const _Section({required this.icon, required this.title, required this.body});

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 10),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ]),
          const SizedBox(height: 8),
          Text(body, style: const TextStyle(fontSize: 15, height: 1.6)),
        ],
      ),
    ),
  );
}
