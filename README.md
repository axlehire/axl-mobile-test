# AxlHire Mobile Test
This repo contains a collection of frameworks, utilities, and other goodies that make writing all kinds of tests at AxleHire effortless.

## Integration Test Framework
Integration tests can be hard to write. They run against real API services and require the app to be running on real devices or emulators. Many factors make it difficult to get integration tests to run consistently and reliably. Additionally, they can be difficult to maintain when we add new features or make adjustments to the app over time. In order for our integration tests to be effective they need to be:
  1. Easy to write
  2. Easy to maintain
  3. Easy to read and understand
  4. Reliable

This repo includes an integration test framework that aims to help us achieve these goals.

### General Structure
#### AppPage
In order to allow the tests to be easy to write and maintain, we need basic building blocks that reflect the logical structure of our app from a user's perspective. Fundamentally, an app is composed of screens screens or "Pages". Each AppPage presents the user with data and interactive features. AppPages represent this organization and provide a place for us to describe each screen in our app in terms of what it displays, what it can do, and how it connects to other screens (transitions).

The important benefit that AppPage organization provides is that it gives us a context for every action that can be performed in the app. There might be a dozen buttons in the app that have the text "Submit". And so, a global function called `pushTheSubmitButton()` is not nearly as valuable or clear as having a page like "BankInfoFormPage" which has a function called `submitBankInfo()`. The name of the AppPage helps us understand what the submit button means, where it's located, and what it is supposed to do. Context is everything.

#### Fixture
All tests run with a certain set of assumptions. Fixtures provide a place to do the work necessary to fulfil those assumptions so that the test can run. For example, before you can test whether the user can book a ticket, there must be available tickets for the user to book. In this case you should write a Fixture that ensures that there is a ticket available for the user to book.

#### Workflow
Each test we write should be narrowly focused on verifying just one thing. Tests become complicated and hard to maintain when we try to cover too much functionality in one test. Each page in our app offers many features. Each feature is designed to behave in different ways depending on application state. Each feature may connect to other pages with still more features. The number of branching pathways that a user can take through our app grows exponentially as we add new pages and new features. It's a bad idea to write tests that try to "do it all". It's tempting to combine tests in an effort to limit the number of tests that we write. However, this leads to tests that are hard to write, hard to maintain, hard to follow and understand, and are often flaky. These are not the things we want. 

Workflows combine AppPages and Fixtures to describe complete user interactions. Workflows typically have a starting AppPage and return a AppPage that represents the state of the app when the workflow completes. The workflow then runs any necessary fixtures and controls one or more pages to perform the user interaction. For example, consider several possible workflows around authentication:
  1. SuccessfulLoginWorkflow: This workflow assumes the user is logged out and depends on the LoginPage. It enters correct credentials in the LoginPage and taps the login button. After successful login it redirects to the home page when complete.
  2. BadPasswordLoginWorkflow: This workflow likewise assumes the user is logged out and depends on the LoginPage. It enters a valid username but an invalid password. After failure, it returns the same LoginPage since the app is in the same state as before the workflowRan.

Next consider possible booking workflows:
  1. SuccessfulBookTicketWorkflow: This workflow assumes the user is on the home page. It would run a fixture designed to ensure that there are active booking sessions available. It navigates to the booking tab, selects an open booking ticket session and books a ticket and selects an arrival time. It then navigates back to the home screen and selects the active assignment screen and returns the active assignment AppPage.
  2. SuccessfulDirectBookingWorkflow: This workflow assumes the user in on the home page. It would run a Fixture designed to ensure that there are direct booking assignments available. It navigates to the booking tab and selects a direct booking assignment. Once booked, it returns to the home screen and selects the assignment tab and returns the active assignment AppPage.

The power of organizing our test code into Pages, Fixtures, and Workflows is that all the pieces can be easily "plugged" together to create as many test combinations as we need. The SuccessfulLoginWorkflow returns the home AppPage when it finishes. Since the SuccessfulBookingTicketWorkflow and the SuccessfulDirectBookingWorkflow both require the home page as a starting point, we can "plug in" the SuccessfulLoginWorkflow into both our booking workflows in two different tests. Consider the following pseudocode:

```dart
void main() {
  testWidgets("Driver can book a ticket successfully", (tester) async {
    final homePage = await SuccessfulLoginWorkflow(username: "scooby", password: "doo").perform();
    final assignmentPage = await SuccessfulBookTicketWorkflow(homePage: homePage).perform();
  });

  testWidgets("Driver can book a direct assignment successfully", (tester) async {
    final homePage = await SuccessfulLoginWorkflow(username: "scooby", password: "doo").perform();
    final assignmentPage = await SuccessfulDirectBookingWorkflow(homePage: homePage).perform();
  });
}
```

This architecture helps us share code and makes the tests we write easy to follow and self-documenting. Anyone can ready these tests and understand instantly what is happening. Similarly, the code within each workflow is designed to be easy to read and understand. Consider this workflow pseudocode:

```dart
class SuccessfulDirectBookingWorkflow extends Workflow<AssignmentPage> {
  final HomePage homePage;
  final AvailableTicketBookingFixture ticketBookingFixture;
  
  SuccessfulDirectBookingWorkflow(this.homePage, this.ticketBookingFixture);
  
  Future<AssignmentPage> perform() async {
    final bookingSessionId = await ticketBookingFixture.perform();
    final bookingPage = await homePage.tapOnBookingTab();
    final ticketsPage = await bookingPage.tapOnBookingSession(bookingSessionId);
    await ticketsPage.bookFirstTicket();
    await ticketsPage.reserveFirstPickupTime();
    await ticketsPage.goBack();
    await bookingPage.goBack();
    final assignmentPage = await homePage.tapOnAssignmentsTab();
    return assignmentPage;
  }
}
```

This code is just a rough outline of what a real test might look like; but it is a good illustration of how this architecture helps ensure that tests are easy to write, maintain, and understand. AppPages, Fixtures, and Workflows follow simple rules so that they can be combined together to easily construct all the tests we need without having to duplicate code.
