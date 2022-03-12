import 'app_page.dart';

/// A workflow is a basic, yet fundamental component of the integration test framework.
/// A workflow has a single method: [perform]. This method executes the workflow
/// and finishes by transitioning to [T] which is a new [AppPage]
///
/// Workflows are a simple concept but they provide a great basic building block
/// for any test.
///
/// Consider a workflow called "SuccessfulLoginWorkflow".
///
/// Important points to remember:
///   1. The name of the workflow is important. The Workflow should clearly describe the entire workflow.
///   In this example we know that the workflow will demonstrate that the app can login successfully.
///   2. Good workflows should test just one thing. In this case the workflow will test that the app
///   can login successfully. It's not concerned with the many branching paths that may be taken.
///   3. Workflows transition the application from one state to another. Good workflows should require
///   a certain app state *before* they run and should guarantee a certain app state *after* they run.
///   In this example, in order to run the "SuccessfulLoginWorkflow" the app should be logged out and
///   on the login screen. So this workflow might require as an argument, an [AppPage] that represents
///   the login screen. The workflow should then return an [AppPage] that represents the screen *after*
///   a successful login.
///
abstract class Workflow<T extends AppPage> {
  Future<T> perform();
}