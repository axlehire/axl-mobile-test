import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

import 'app_page.dart';

/// This page is a sub for when we don't need a page context, such as at the end of a test
class VoidPage<T> extends AppPage<T> {
  VoidPage(WidgetTester tester, T appState) : super(tester, appState);

  @override
  List<Key> get screenKeys => [const Key("void-page")];

  @override
  Future<void> awaitVisible(
      [Duration maxDuration = const Duration(seconds: 5)]) async {
    throw "void page is never visible";
  }
}
