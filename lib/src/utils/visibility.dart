import 'package:flutter_test/flutter_test.dart';

Future<bool> awaitElementVisible(
    WidgetTester tester, Future<bool> Function() elementIsShowing,
    [Duration maxDuration = const Duration(seconds: 5)]) async {
  final startCheckTime = DateTime.now();
  while (DateTime.now().difference(startCheckTime) < maxDuration) {
    await tester.pumpAndSettle();
    if (await elementIsShowing()) {
      // it's visible, return early
      return true;
    }
  }
  return false;
}
