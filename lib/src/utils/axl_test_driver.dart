import 'package:flutter_test/flutter_test.dart';

class AxlTestDriver {
  static late WidgetTester tester;

  static setup(WidgetTester widgetTester) async {
    tester = widgetTester;
  }
}
