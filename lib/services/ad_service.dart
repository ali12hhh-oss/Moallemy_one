import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdService {
  static const appId = 'ca-app-pub-8995513369904529~1635103101';
  static const bannerAdUnitId = 'ca-app-pub-8995513369904529/1551342629';
  static const interstitialAdUnitId = 'ca-app-pub-8995513369904529/9673822334';
  static const rewardedAdUnitId = 'ca-app-pub-8995513369904529/4477335972';
  static const nativeAdUnitId = 'ca-app-pub-8995513369904529/4484627723';

  static const _lastAdKey = 'ads_last_shown_ms';
  static const _storyKey = 'ads_story_completed_count';
  static const _gameKey = 'ads_game_completed_count';
  static const _levelKey = 'ads_level_completed_count';
  static const cooldown = Duration(minutes: 5);

  static InterstitialAd? _interstitial;
  static RewardedAd? _rewarded;
  static bool _inlineReservation = false;

  static Future<void> initialize() async {
    await MobileAds.instance.updateRequestConfiguration(
      RequestConfiguration(
        tagForChildDirectedTreatment: TagForChildDirectedTreatment.yes,
        maxAdContentRating: MaxAdContentRating.g,
      ),
    );
    await MobileAds.instance.initialize();
    await _loadInterstitial();
    await _loadRewarded();
  }

  static Future<bool> canShowAd() async {
    final prefs = await SharedPreferences.getInstance();
    final last = prefs.getInt(_lastAdKey) ?? 0;
    return DateTime.now().millisecondsSinceEpoch - last >= cooldown.inMilliseconds;
  }

  static Future<void> markAdShown() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastAdKey, DateTime.now().millisecondsSinceEpoch);
  }

  static Future<bool> reserveInlineAdSlot() async {
    if (_inlineReservation) return false;
    _inlineReservation = true;
    if (!await canShowAd()) {
      _inlineReservation = false;
      return false;
    }
    return true;
  }

  static void releaseInlineAdSlot() {
    _inlineReservation = false;
  }

  static Future<void> _loadInterstitial() async {
    await InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) => _interstitial = ad,
        onAdFailedToLoad: (_) => _interstitial = null,
      ),
    );
  }

  static Future<void> _loadRewarded() async {
    await RewardedAd.load(
      adUnitId: rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) => _rewarded = ad,
        onAdFailedToLoad: (_) => _rewarded = null,
      ),
    );
  }

  static Future<bool> showInterstitial() async {
    if (!await canShowAd() || _interstitial == null) return false;
    final ad = _interstitial!;
    _interstitial = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => markAdShown(),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadInterstitial();
      },
    );
    ad.show();
    return true;
  }

  static Future<bool> showRewarded({required Future<void> Function() onReward}) async {
    if (!await canShowAd() || _rewarded == null) return false;
    final ad = _rewarded!;
    _rewarded = null;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (_) => markAdShown(),
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _loadRewarded();
      },
      onAdFailedToShowFullScreenContent: (ad, _) {
        ad.dispose();
        _loadRewarded();
      },
    );
    ad.show(onUserEarnedReward: (_, reward) async {
      if (reward.amount > 0) {
        await onReward();
      }
    });
    return true;
  }

  static Future<int> incrementCompletedActivity(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = switch (type) {
      'story' => _storyKey,
      'game' => _gameKey,
      'level' => _levelKey,
      _ => throw ArgumentError('Unknown activity type: $type'),
    };
    final count = (prefs.getInt(key) ?? 0) + 1;
    await prefs.setInt(key, count);
    return count;
  }

  /// Called after the child leaves an activity. Leaving early still counts as
  /// completing that activity for the ad cadence; the learning/game page is
  /// never interrupted by an ad.
  static Future<bool> completeActivityOnExit(String type) async {
    final count = await incrementCompletedActivity(type);
    if (count < 3) return false;
    final shown = await showInterstitial();
    if (shown) {
      await resetCompletedActivityCount(type);
    }
    return shown;
  }

  static Future<int> completedActivityCount(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = switch (type) {
      'story' => _storyKey,
      'game' => _gameKey,
      'level' => _levelKey,
      _ => throw ArgumentError('Unknown activity type: $type'),
    };
    return prefs.getInt(key) ?? 0;
  }

  static Future<void> resetCompletedActivityCount(String type) async {
    final prefs = await SharedPreferences.getInstance();
    final key = switch (type) {
      'story' => _storyKey,
      'game' => _gameKey,
      'level' => _levelKey,
      _ => throw ArgumentError('Unknown activity type: $type'),
    };
    await prefs.setInt(key, 0);
  }
}
