import 'package:flutter/material.dart';

import '../../core/localization/arabic_numbers.dart';
import '../../core/settings/app_preferences_v10.dart';
import 'help_screen.dart';
import 'privacy_policy_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final prefs = AppPreferencesV10.instance;
  void open(BuildContext c, Widget w) =>
      Navigator.push(c, MaterialPageRoute(builder: (_) => w));
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: prefs,
        builder: (context, _) => Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            appBar: AppBar(title: const Text('الإعدادات')),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(18),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 27,
                          child: Text('⚙️', style: TextStyle(fontSize: 24)),
                        ),
                        SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'اجعل تجربة التعلم مناسبة لطفلك',
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
                SwitchListTile(
                  title: const Text('الوضع الليلي'),
                  subtitle: const Text('راحة للعين أثناء التعلم ليلاً'),
                  value: prefs.themeMode == ThemeMode.dark,
                  onChanged: prefs.setDarkMode,
                ),
                SwitchListTile(
                  title: const Text('أصوات النطق'),
                  subtitle: const Text('تشغيل أصوات الحروف والكلمات'),
                  value: prefs.sounds,
                  onChanged: prefs.setSounds,
                ),
                SwitchListTile(
                  title: const Text('المؤثرات'),
                  subtitle: const Text('مؤثرات النجاح والتنبيه داخل الألعاب'),
                  value: prefs.effects,
                  onChanged: prefs.setEffects,
                ),
                Card(
                  child: ListTile(
                    title: const Text('مدة جلسة التعلم'),
                    subtitle: Text('${arNum(prefs.sessionMinutes)} دقيقة'),
                    trailing: DropdownButton<int>(
                      value: prefs.sessionMinutes,
                      items: [10, 15, 20, 30, 45]
                          .map(
                            (x) => DropdownMenuItem(
                              value: x,
                              child: Text(arNum(x)),
                            ),
                          )
                          .toList(),
                      onChanged: (v) {
                        if (v != null) prefs.setSessionMinutes(v);
                      },
                    ),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.menu_book_rounded),
                    title: const Text('تعليمات الاستخدام'),
                    subtitle: const Text('دليل سريع لاستخدام التطبيق مع طفلك'),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => open(context, const HelpScreen()),
                  ),
                ),
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.lock_outline_rounded),
                    title: const Text('الخصوصية والعمل دون اتصال'),
                    subtitle: const Text(
                      'التقدم الأساسي محفوظ محلياً ويمكن للطفل التعلم دون اتصال.',
                    ),
                    trailing: const Icon(Icons.chevron_left_rounded),
                    onTap: () => open(context, const PrivacyPolicyScreen()),
                  ),
                ),
                const Card(
                  child: ListTile(
                    title: Text('الإصدار'),
                    subtitle: Text(
                      'معلمي — الإصدار ١.٠.٠ (الإصدار الأول الرسمي)',
                    ),
                    leading: Icon(Icons.auto_awesome_rounded),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
