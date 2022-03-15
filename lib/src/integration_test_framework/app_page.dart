import 'package:axl_mobile_test/src/utils/visibility.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';

import '../utils/page_testing_utils.dart';

/// The [AppPage] is a fundamental component of the integration test framework.
/// An [AppPage] represents a logical "screen" in the app; a visual representation
/// of the app's current state. [AppPages] provide convenient methods to perform all
/// the functionality that the user can perform on the particular screen.
///
/// [AppPage]s do not need to necessarily mirror widgets in the codebase exactly.
/// A screen may be composed of many widgets and some widgets have several functionality
/// modes. The appropriate scope for an [AppPage] is what the user can do when the app
/// is in a particular state.
///
/// For example, suppose the app is currently logged out. What can the user do?
/// "what screen does the user see?" In this case the user is looking at the Login screen.
/// The only things that the user can do on the Login screen is to login or transition
/// the app's state to the new user registration screen. Therefore, we might add a
/// [AppPage] called "LoginPage". the "LoginPage" would have a login method which
/// takes a username and password. It would also have a "registerNewUser" function
/// which performs a transition to another page we might call "RegistrationPage" and
/// the function should return and instance of the "RegistrationPage".
///
/// The main point of this distinction is to provide a consistent and intuitive API
/// for our integration tests by organizing the thousands of things our apps can do
/// into classes which represent the screens in which each of those functions are
/// applicable. Testing becomes much easier this way.
abstract class AppPage<S> {
  final WidgetTester tester;
  final S appState;

  AppPage(this.tester, this.appState);

  Future<void> delayed(
      [Duration duration = const Duration(milliseconds: 100)]) async {
    await tester.pumpAndSettle(duration);
  }

  Future writeLog(String message) async {
    tester.printToConsole(message);
  }

  Future clickButton(String keyString) async {
    final key = Key(keyString);
    return clickButtonWithKey(key);
  }

  Future<void> clickButtonWithKey(Key key) async {
    final finder = find.byKey(key);
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  Future<void> verifyKeyIsInScreen(String key) async {
    expect(
      await PageTestingUtils.isKeyInScreen(tester: tester, key: Key(key)),
      true,
      reason: 'Should be in $key',
    );
  }

  Future<void> verifyKeyIsNotInScreen(String key) async {
    final keyFinder = find.byKey(Key(key));
    expect(
      await PageTestingUtils.isPresent(tester: tester, finder: keyFinder),
      false,
      reason: 'Should not be in $key',
    );
  }

  Future<bool> screenIsShowing() async {
    for (final key in screenKeys) {
      final showing =
          await PageTestingUtils.isKeyInScreen(tester: tester, key: key);
      if (showing) {
        return true;
      }
    }
    return false;
  }

  /// These are the keys on the screen that indicates that the screen is visible when present
  /// Only one of the included keys needs to be present in order to determine that the screen is
  /// visible
  List<Key> get screenKeys;

  /// This waits until the page is clearly visible
  ///
  /// We will continue to pump until we timeout
  Future<void> awaitVisible(
      [Duration maxDuration = const Duration(seconds: 5)]) async {
    final isVisible = await awaitElementVisible(tester, () => screenIsShowing());
    if (!isVisible) {
      throw 'Element Not Visible after ${maxDuration.inSeconds} seconds';
    }
  }

  Future<void> performOnPage(Future<void> Function() action,
      [Duration maxDuration = const Duration(seconds: 5)]) async {
    await awaitVisible(maxDuration);
    await action();
  }
}
