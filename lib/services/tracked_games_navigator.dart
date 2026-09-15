import 'package:flutter/material.dart';

import 'ad_service.dart';

/// Hosts a game hub inside a nested Navigator so individual game routes can
/// be counted when the child leaves each game, without modifying the game
/// implementations themselves.
class TrackedGamesNavigator extends StatefulWidget {
  const TrackedGamesNavigator({super.key, required this.child});

  final Widget child;

  @override
  State<TrackedGamesNavigator> createState() => _TrackedGamesNavigatorState();
}

class _TrackedGamesNavigatorState extends State<TrackedGamesNavigator> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late final _observer = _GameRouteObserver(_onGameExit);

  void _onGameExit() {
    AdService.completeActivityOnExit('game');
  }

  Future<bool> _handleBack() async {
    if (_observer.depth > 1) {
      _navigatorKey.currentState?.pop();
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<Object?>(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        if (await _handleBack() && context.mounted) {
          Navigator.of(context).pop(result);
        }
      },
      child: Navigator(
        key: _navigatorKey,
        observers: [_observer],
        onGenerateRoute: (_) => MaterialPageRoute(builder: (_) => widget.child),
      ),
    );
  }
}

class _GameRouteObserver extends NavigatorObserver {
  _GameRouteObserver(this.onGameExit);

  final VoidCallback onGameExit;
  int depth = 0;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (route is PageRoute<dynamic>) depth++;
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (route is PageRoute<dynamic>) {
      if (depth > 1) onGameExit();
      depth = depth > 0 ? depth - 1 : 0;
    }
  }
}
