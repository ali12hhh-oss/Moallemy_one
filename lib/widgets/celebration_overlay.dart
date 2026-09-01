import 'package:flutter/material.dart';

/// كلمة تشجيعية تظهر في منتصف الشاشة لمدة قصيرة.
///
/// هذا الـWidget مسؤول عن العرض والحركة فقط.
/// أصوات الإجابات الصحيحة/الخاطئة تُشغّلها شاشة الاختبار نفسها،
/// حتى لا تتسرب أصوات التشجيع إلى الدروس أو الأقسام التعليمية.
class CelebrationOverlay extends StatefulWidget {
  final String? message;
  final Duration duration;
  const CelebrationOverlay({
    super.key,
    required this.message,
    this.duration = const Duration(seconds: 2),
  });

  @override
  State<CelebrationOverlay> createState() => _CelebrationOverlayState();
}

class _CelebrationOverlayState extends State<CelebrationOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<double> scale;

  static const gradients = [
    [Color(0xFFFFD54F), Color(0xFFFF7043)],
    [Color(0xFF66BB6A), Color(0xFF00BFA6)],
    [Color(0xFF7C4DFF), Color(0xFF2979FF)],
    [Color(0xFFFF1E7E), Color(0xFFFB8C00)],
  ];

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    scale = CurvedAnimation(parent: controller, curve: Curves.elasticOut);
    _handleMessageChange(current: widget.message);
  }

  @override
  void didUpdateWidget(covariant CelebrationOverlay oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.message == oldWidget.message) return;
    _handleMessageChange(current: widget.message);
  }

  void _handleMessageChange({String? current}) {
    if (current == null) {
      controller.reset();
      return;
    }
    controller.forward(from: 0);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final msg = widget.message;
    return IgnorePointer(
      child: Center(
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: msg == null
              ? const SizedBox.shrink()
              : ScaleTransition(
                  // ثابت لنفس الرسالة؛ لا نستخدم DateTime.now لأن ذلك
                  // كان يعيد تشغيل الظهور والصوت مع كل rebuild.
                  key: ValueKey(msg),
                  scale: scale,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                      vertical: 18,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradients[msg.length % gradients.length],
                      ),
                      borderRadius: BorderRadius.circular(26),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Text(
                      msg,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

const kCheers = [
  'أحسنت! 🎉',
  'رائع يا بطل! 🌟',
  'ممتاز! 🏆',
  'صح! 👏',
  'شاطر! 💎',
  'عاش! ✨',
];
