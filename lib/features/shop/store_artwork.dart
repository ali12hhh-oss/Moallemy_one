import 'dart:math' as math;

import 'package:flutter/material.dart';

class StoreArtwork extends StatelessWidget {
  final String art;
  final bool background;
  const StoreArtwork({super.key, required this.art, this.background = false});

  @override
  Widget build(BuildContext context) {
    final parts = art.split(':');
    final kind = parts.isNotEmpty ? parts.first : 'special';
    final index = parts.length > 1 ? int.tryParse(parts[1]) ?? 0 : 0;
    return CustomPaint(
      painter: _StoreArtworkPainter(kind: kind, index: index, background: background),
      child: const SizedBox.expand(),
    );
  }
}

class _StoreArtworkPainter extends CustomPainter {
  final String kind;
  final int index;
  final bool background;
  _StoreArtworkPainter({required this.kind, required this.index, required this.background});

  static const colors = <Color>[
    Color(0xFFFFB74D), Color(0xFF42A5F5), Color(0xFF66BB6A), Color(0xFFAB47BC),
    Color(0xFFEF5350), Color(0xFF26A69A), Color(0xFFFFCA28), Color(0xFFFF7043),
    Color(0xFF5C6BC0), Color(0xFF26C6DA),
  ];

  Color get c => colors[index % colors.length];
  Color get c2 => colors[(index + 3) % colors.length];

  @override
  void paint(Canvas canvas, Size size) {
    if (background || kind == 'background') {
      _paintBackground(canvas, size);
      return;
    }
    final s = math.min(size.width, size.height);
    final center = Offset(size.width / 2, size.height / 2);
    final base = Paint()..color = c;
    canvas.drawCircle(center, s * .43, base);
    final p = Paint()..color = Colors.white.withValues(alpha: .94);
    final accent = Paint()..color = c2;

    switch (kind) {
      case 'أوسمة':
        _badge(canvas, center, s, accent);
      case 'شخصيات':
        _character(canvas, center, s, accent);
      case 'إكسسوارات':
        _accessory(canvas, center, s, accent);
      case 'رياضة':
        _sport(canvas, center, s, accent);
      case 'أدوات تعليمية':
        _tool(canvas, center, s, accent);
      case 'جوائز خاصة':
        _special(canvas, center, s, accent);
      case 'title':
        _title(canvas, center, s, accent);
      default:
        _special(canvas, center, s, accent);
    }
  }

  void _badge(Canvas canvas, Offset m, double s, Paint accent) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final a = -math.pi / 2 + i * math.pi / 5;
      final r = i.isEven ? s * .30 : s * .19;
      final p = Offset(m.dx + math.cos(a) * r, m.dy + math.sin(a) * r);
      if (i == 0) path.moveTo(p.dx, p.dy); else path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = const Color(0xFFFFE082));
    canvas.drawCircle(m, s * .11, accent);
    canvas.drawCircle(m, s * .065, Paint()..color = Colors.white);
  }

  void _character(Canvas canvas, Offset m, double s, Paint accent) {
    final skin = [const Color(0xFFFFD7B3), const Color(0xFFE8B88F), const Color(0xFFC99163)][index % 3];
    canvas.drawCircle(Offset(m.dx, m.dy - s * .08), s * .20, Paint()..color = skin);
    canvas.drawOval(Rect.fromCenter(center: Offset(m.dx, m.dy - s * .20), width: s * .42, height: s * .20), Paint()..color = const Color(0xFF4E342E));
    canvas.drawCircle(Offset(m.dx - s * .08, m.dy - s * .08), s * .028, Paint()..color = Colors.black87);
    canvas.drawCircle(Offset(m.dx + s * .08, m.dy - s * .08), s * .028, Paint()..color = Colors.black87);
    final body = RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(m.dx, m.dy + s * .20), width: s * .42, height: s * .30), Radius.circular(s * .08));
    canvas.drawRRect(body, accent);
    canvas.drawCircle(Offset(m.dx, m.dy + s * .17), s * .055, Paint()..color = Colors.white.withValues(alpha: .9));
  }

  void _accessory(Canvas canvas, Offset m, double s, Paint accent) {
    final mode = index % 4;
    final p = Paint()..color = accent.color;
    if (mode == 0) {
      canvas.drawOval(Rect.fromCenter(center: Offset(m.dx, m.dy - s * .02), width: s * .42, height: s * .26), p);
      canvas.drawRect(Rect.fromLTWH(m.dx - s * .26, m.dy, s * .52, s * .07), p);
      canvas.drawRect(Rect.fromLTWH(m.dx - s * .12, m.dy - s * .22, s * .24, s * .12), Paint()..color = c);
    } else if (mode == 1) {
      final q = Paint()..color = Colors.white..style = PaintingStyle.stroke..strokeWidth = s * .035;
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(m.dx - s*.13,m.dy), width:s*.22,height:s*.18), Radius.circular(s*.04)),q);
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(m.dx + s*.13,m.dy), width:s*.22,height:s*.18), Radius.circular(s*.04)),q);
      canvas.drawLine(Offset(m.dx-s*.02,m.dy), Offset(m.dx+s*.02,m.dy), q);
    } else if (mode == 2) {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: m, width:s*.34,height:s*.46), Radius.circular(s*.08)), p);
      canvas.drawCircle(Offset(m.dx,m.dy+s*.06), s*.07, Paint()..color=Colors.white.withValues(alpha:.8));
    } else {
      final path=Path()..moveTo(m.dx,m.dy-s*.23)..lineTo(m.dx+s*.09,m.dy-s*.08)..lineTo(m.dx+s*.22,m.dy-s*.08)..lineTo(m.dx+s*.11,m.dy+s*.01)..lineTo(m.dx+s*.15,m.dy+s*.16)..lineTo(m.dx,m.dy+s*.08)..lineTo(m.dx-s*.15,m.dy+s*.16)..lineTo(m.dx-s*.11,m.dy+s*.01)..lineTo(m.dx-s*.22,m.dy-s*.08)..lineTo(m.dx-s*.09,m.dy-s*.08)..close();
      canvas.drawPath(path, Paint()..color=const Color(0xFFFFD740));
    }
  }

  void _sport(Canvas canvas, Offset m, double s, Paint accent) {
    canvas.drawCircle(m, s*.25, Paint()..color=Colors.white);
    final p=Paint()..color=accent.color..strokeWidth=s*.035..style=PaintingStyle.stroke;
    for(int i=0;i<5;i++){
      final a=i*2*math.pi/5;
      final q=Offset(m.dx+math.cos(a)*s*.25,m.dy+math.sin(a)*s*.25);
      canvas.drawLine(m,q,p);
    }
    final pent=Path();
    for(int i=0;i<5;i++){
      final a=-math.pi/2+i*2*math.pi/5;
      final q=Offset(m.dx+math.cos(a)*s*.11,m.dy+math.sin(a)*s*.11);
      if(i==0)pent.moveTo(q.dx,q.dy);else pent.lineTo(q.dx,q.dy);
    }
    pent.close();canvas.drawPath(pent,Paint()..color=accent.color);
  }

  void _tool(Canvas canvas, Offset m, double s, Paint accent) {
    if(index%3==0){
      for(int i=0;i<3;i++) canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(m.dx-s*.27,m.dy+s*.18-i*s*.11,s*.54,s*.08),Radius.circular(6)), Paint()..color=colors[(index+i)%10]);
    } else if(index%3==1){
      canvas.drawRect(Rect.fromCenter(center:m,width:s*.54,height:s*.10),Paint()..color=const Color(0xFFFFE082));
      for(int i=0;i<5;i++) canvas.drawRect(Rect.fromLTWH(m.dx-s*.20+i*s*.09,m.dy-s*.05,s*.02,s*.12),accent);
    } else {
      final p=Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=s*.04;
      canvas.drawCircle(m,s*.25,p);canvas.drawLine(Offset(m.dx-s*.16,m.dy),Offset(m.dx+s*.16,m.dy),p);canvas.drawLine(Offset(m.dx,m.dy-s*.16),Offset(m.dx,m.dy+s*.16),p);
    }
  }

  void _special(Canvas canvas, Offset m, double s, Paint accent) {
    canvas.drawCircle(m,s*.25,Paint()..color=Colors.white);
    if(index.isEven){
      final path=Path(); for(int i=0;i<10;i++){final a=-math.pi/2+i*math.pi/5;final r=i.isEven?s*.26:s*.12;final q=Offset(m.dx+math.cos(a)*r,m.dy+math.sin(a)*r);if(i==0)path.moveTo(q.dx,q.dy);else path.lineTo(q.dx,q.dy);} path.close();canvas.drawPath(path,Paint()..color=const Color(0xFFFFD740));
    } else {
      canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center:m,width:s*.30,height:s*.42),Radius.circular(s*.05)),accent);
      canvas.drawRect(Rect.fromCenter(center:Offset(m.dx,m.dy-s*.07),width:s*.17,height:s*.10),Paint()..color=Colors.white);
    }
  }

  void _title(Canvas canvas, Offset m, double s, Paint accent) {
    final shield=Path()..moveTo(m.dx-s*.22,m.dy-s*.26)..lineTo(m.dx+s*.22,m.dy-s*.26)..lineTo(m.dx+s*.18,m.dy+s*.14)..quadraticBezierTo(m.dx,m.dy+s*.28,m.dx-s*.18,m.dy+s*.14)..close();
    canvas.drawPath(shield,Paint()..color=const Color(0xFFFFD740));
    canvas.drawCircle(Offset(m.dx,m.dy-s*.04),s*.10,accent);
    final p=Paint()..color=Colors.white..style=PaintingStyle.stroke..strokeWidth=s*.025;
    canvas.drawCircle(Offset(m.dx,m.dy-s*.04),s*.13,p);
  }

  void _paintBackground(Canvas canvas, Size size) {
    final colorsA=[const Color(0xFFB3E5FC),const Color(0xFFA5D6A7),const Color(0xFF3949AB),const Color(0xFF26A69A),const Color(0xFF90CAF9),const Color(0xFFFFCC80),const Color(0xFFCE93D8),const Color(0xFF81C784),const Color(0xFFB39DDB),const Color(0xFFFFB74D)];
    final colorsB=[const Color(0xFFF8BBD0),const Color(0xFFFFE082),const Color(0xFF7E57C2),const Color(0xFF80CBC4),const Color(0xFF42A5F5),const Color(0xFFFFF59D),const Color(0xFFFFCC80),const Color(0xFFA5D6A7),const Color(0xFF80DEEA),const Color(0xFFFFE082)];
    final rect=Offset.zero & size;
    final g=Paint()..shader=LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,colors:[colorsA[index%10],colorsB[index%10]]).createShader(rect);
    canvas.drawRect(rect,g);
    final p=Paint()..color=Colors.white.withValues(alpha:.16);
    final rnd=math.Random(index+17);
    for(int i=0;i<16;i++){final x=rnd.nextDouble()*size.width;final y=rnd.nextDouble()*size.height;final r=8+rnd.nextDouble()*24;canvas.drawCircle(Offset(x,y),r,p);}
    final sun=Paint()..color=Colors.white.withValues(alpha:.28);canvas.drawCircle(Offset(size.width*.82,size.height*.2),math.min(size.width,size.height)*.12,sun);
    final ground=Paint()..color=Colors.white.withValues(alpha:.18);canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0,size.height*.72,size.width,size.height*.28),Radius.circular(28)),ground);
  }

  @override
  bool shouldRepaint(covariant _StoreArtworkPainter oldDelegate) => oldDelegate.kind != kind || oldDelegate.index != index || oldDelegate.background != background;
}
