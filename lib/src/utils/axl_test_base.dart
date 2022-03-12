import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'axl_test_driver.dart';

class AxlTestBase {
  static Future clickButton(String key) async {
    final Finder btn = find.byKey(Key(key));
    expect(await _isPresent (btn), true);
    await AxlTestDriver.tester.tap(btn);
  }

  static Future clickIfPresent(String key) async {
    final Finder btn = find.byKey(Key(key));
    final bool isExist = await _isPresent(btn);

    if (isExist) await AxlTestDriver.tester.tap(btn);
  }

  static Future<bool> isPresent(String key) async {
    final Finder btn = find.byKey(Key(key));
    return await _isPresent(btn);
  }

  static Future<bool> _isPresent(Finder finder) async {
    try {
      await AxlTestDriver.tester.pumpAndSettle();
      expect(finder, findsOneWidget);
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> expectTextValue(String key, String expectedValue) async {
    final Finder txtBox = find.byKey(Key(key));
    expect(await _isPresent(txtBox), true);
    expect(find.text(expectedValue), findsOneWidget);
  }
}
