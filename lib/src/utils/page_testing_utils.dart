import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

abstract class PageTestingUtils {
  PageTestingUtils._();

  /// Tests whether a given finder can be found on the screen
  static Future<bool> isPresent(
      {required WidgetTester tester, required Finder finder}) async {
    try {
      tester.ensureVisible(finder);
      return true;
    } catch (e) {
      tester.printToConsole(e.toString());
      return false;
    }
  }

  static Future<bool> isKeyInScreen({
    required WidgetTester tester,
    required Key key,
  }) async {
    final keyFinder = find.byKey(key);
    return await isPresent(
      tester: tester,
      finder: keyFinder,
    );
  }

}
