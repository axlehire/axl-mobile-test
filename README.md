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
In order to allow the tests to be easy to write and maintain, we need basic building blocks that reflect the logical structure of our app from a user's perspective. Fundamentally, an app is composed of screens screens or "Pages". Each Page presents the user with data and interactive features. AppPages represent this organization and provide a place for us to describe each screen in our app in terms of what it displays, what it can do, and how it connects to other screens (transitions).

#### Workflow
Each test we write should be narrowly focused on verifying just one thing. Tests become complicated and hard to maintain when they cover too much functionality. Each page in our app offers many features. Each feature may connect to other pages with still more features. The number of branching pathways that a user can take through our app can grow exponentially as we add new pages and new features. It's a bad idea to write tests that try to "do it all". It's tempting to combine tests in an effort to limit the number of tests that we write. However, this leads to tests that are hard to write, hard to maintain, hard to follow and understand, and are often flaky. These are not the things we want. Workflows 
