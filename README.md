# CryptoApp

## Building and Running the App

To build and run CryptoApp on your local machine, follow these steps:

### Prerequisites

- Ensure you have Flutter installed on your machine. If not, follow the installation guide [here](https://docs.flutter.dev/get-started/install).
- An IDE with Flutter support (e.g., Android Studio, VS Code) is recommended for a seamless development experience.

### Installation

1. Clone the repository to your local machine:

git clone https://github.com/nestorsgarzonc/crypto_app

2. Navigate to the project directory:

cd crypto_app

3. Install the project dependencies:

flutter pub get

### Running the App

To run the app on an emulator or connected device, use the following command:

flutter run

### Building the App

To build the app for a specific platform (e.g., Android, iOS), use the following command:

flutter build <platform>

Replace <platform> with the desired platform (e.g., android, ios).

### DOC

Welcome to CryptoApp, a cutting-edge Flutter application designed to deliver real-time cryptocurrency data. This README provides an in-depth look at the project's architecture, design patterns, development practices, and more, ensuring a robust, maintainable, and scalable codebase.

## Architecture Overview

CryptoApp adopts a Clean Architecture approach, structured to promote separation of concerns, scalability, and testability. The architecture is organized into several key layers:

- **Presentation Layer**: Ensure a clear separation between UI logic and business logic. This layer is responsible for UI rendering and user interactions.
- **State Management**: Utilizes the Provider package for managing state, facilitating a reactive and efficient data flow between the UI and the business logic layers.
- **Service Layer**: Acts as the core business logic layer, abstracting the complexity of data operations and providing a clean API for data manipulation and business rules implementation.
- **Data Access Layer**: Handles all interactions with external data sources, such as APIs or Firebase, ensuring data is fetched, cached, and persisted correctly.

### Design Patterns and Code Organization

- **Code Organization**: The project follows a feature-first organization strategy, grouping related code by feature rather than by layer, which helps in maintaining a clean and navigable codebase free from code smells.

### Routing

- **Routing**: CryptoApp leverages the GoRouter package for routing, providing a declarative and flexible approach to managing navigation within the app. This supports complex routing scenarios, including nested routes and deep linking.

### Testing

- **Unit and Integration Testing**: Comprehensive unit tests cover the domain and service layers, while integration tests verify the interaction between components, especially focusing on the integration of the presentation layer with state management.
- **State Management Testing**: Specific tests are designed to ensure the reliability and performance of the state management solution, verifying that state changes result in the correct UI updates.

### Code Documentation and Exception Handling

- **Code Documentation**: Thorough documentation is provided throughout the codebase, explaining the purpose and functionality of major components and methods, facilitating easier maintenance and onboarding of new developers.
- **Exception Handling**: A robust exception handling strategy is implemented, with try-catch blocks and error handling mechanisms in place to gracefully manage and recover from errors, ensuring a smooth user experience.
