import 'package:flutter/material.dart';
import '../../widgets/button_3d.dart';
import 'g2_games_screen.dart';
import 'g2_stories_screen.dart';

class G2GamesStoriesHub extends StatelessWidget {
  const G2GamesStoriesHub({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('ألعاب وقصص')),
        body: ListView(padding: const EdgeInsets.all(18), children: [
          Button3D(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const G2GamesScreen())),
            color: const Color(0xFF00BFA6),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: const Row(children: [
              Text('🎮', style: TextStyle(fontSize: 40)),
              SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('الألعاب', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('أربع ألعاب: قراءة، إنجليزي، رياضيات، وقواعد', style: TextStyle(color: Colors.white70)),
                ]),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          Button3D(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const G2StoriesScreen())),
            color: const Color(0xFFFF6B35),
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
            child: const Row(children: [
              Text('📖', style: TextStyle(fontSize: 40)),
              SizedBox(width: 16),
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('القصص', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                  SizedBox(height: 4),
                  Text('أربع قصص أطول، بقراءة صوتية كاملة', style: TextStyle(color: Colors.white70)),
                ]),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
