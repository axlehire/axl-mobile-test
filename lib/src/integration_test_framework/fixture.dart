/// A [Fixture] is a simple class which is responsible for configuring application
/// state during a test.
///
/// Suppose we want to create a test which verifies that users can deliver packages
/// with our app. Well, before we can perform an assignment, an assignment must first
/// be created and assigned to the test user. [Fixture]s are responsible for this kind
/// of work.
///
/// Generally, fixtures are run by a [Workflow] and [AppPage]s run assuming that
/// they have all the correct state and dependencies necessary to perform their specific
/// functions
///
abstract class Fixture {
  Future<void> perform();
}
