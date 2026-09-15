import 'package:flutter/material.dart';

import 'app/app.dart';
import 'services/ad_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AdService.initialize();
  runApp(const DaleelChildApp());
}
