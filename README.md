# CatWallet
Application that allows you to explore cat breeds using The Cat API and simulates a Fintech environment where the user has a quota of favorites.

## Characteristics

- **Cat breeds exploration**: Browse a list of cat breeds with images, origin, temperament, and detailed descriptions, including proper handling of loading, error, and empty states.
- **Persistent favorites**: Add and remove favorite cat breeds with local persistence, reflecting changes instantly in the UI.
- **Secure favorites unlocking (tokenization simulation)**: Users can save up to 3 favorite breeds for free. To unlock unlimited favorites, they must link a payment method through a simulated tokenization flow that generates and stores a secure token locally.
- **Reactive UI with SwiftUI**: views and reusable components.
- **Robust networking layer**: Typed API layer with safe decoding, timeout handling, and retry mechanisms.
- **Testing**: Includes unit tests for domain and networking layers.
- **Linting and resource generation**: Integrated with **SwiftLint** and **SwiftGen** to ensure code consistency and type-safe resources.



## Key Features

- **Modular architecture**: Organized into layers that separate responsibilities (Data, Domain, UI, etc.).
- **Modern compatibility**: Built with SwiftUI and compatible with Apple’s latest tools.
- **Advanced testing support**: Includes tools like **Swift Testing** and **SwiftLint**, along with unit testing.



# Modules

CatWallet is designed as a multimodular system to enhance scalability and maintainability. Below is a description of the available modules:

### 1. Features
The main module orchestrating the core operations and functionalities.

### 2. Common
Includes structures, utilities, and reusable classes across the project.

### 3. Core
Includes Coordinator pattern to navigation management in the App.

### 4. DataLayer
Responsible for data management. Includes services, repositories, and logic related to data persistence and consumption.

### 5. DomainLayer
Contains the entities, use cases, and business logic defining the application domain.

### 6. LocalizedString
Manages the texts and wordings used in the application, centralizing localization for multiple languages.

### 7. Networking
Handles network requests and responses, including validations and service-specific configurations.



# Architecture

- **Presentation (SwiftUI)**:  
  - **Views**: Render application state and handle user interaction.  
  - **ViewModels**: Orchestrate presentation logic, expose `@Published` / `@State`, and coordinate navigation flows.

- **Domain**:  
  - **Use cases / Services**: Encapsulate business rules and compose repositories.  
  - **Domain models**: Framework-agnostic entities representing core concepts.

- **Data**:  
  - **Repositories**: Abstractions over data sources (network, cache, persistence).  
  - **Data sources**: Concrete implementations such as APIs and local storage.

- **Infrastructure**:  
  - **Networking**: HTTP client (`URLSession` with `async/await`), decoders, and endpoints.  
  - **Persistence**: Local storage using UserDefaults, SwiftData, or CoreData depending on the use case.

- **Utilities**:  
  - **Helpers and extensions**: Mappers, formatters, and shared utility components.

- **Configuration**:  
  - **Tooling and setup**: SwiftGen, SwiftLint, build schemes, and environment configuration.



# Code Style

The project uses SwiftLint to ensure consistency and adherence to code conventions.


# Requirements

- **Xcode 16+**
- **iOS 16.6+**


### Development Tools Setup

This project uses additional tools to ensure code quality and type-safe resources.  
Make sure you have them installed locally before building the project.

#### Install Homebrew (required)
If you don’t have Homebrew installed:

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

#### Install SwiftLint (required)
Used to enforce code style and best practices.

brew install swiftlint

#### Install SwiftGen (required)
Used to generate type-safe access to localized strings and other resources.

brew install swiftgen



## How to Run

1. Open the project in **Xcode**.
2. Select the **CatWallet** scheme.
3. Run the application using **Cmd + R**.


### Running Tests
- To run unit tests, go to **Product → Test** or press **Cmd + U**.

<img width="400" alt="Test success" src="https://github.com/user-attachments/assets/3b3fa893-d13a-4607-8103-e3d5253337ad" />

# Screenshots

<img width="300" alt="Splash" src="https://github.com/user-attachments/assets/d1a40db5-7ca9-4217-847e-4464d5e769f7" />

<img width="300" alt="Razas" src="https://github.com/user-attachments/assets/cbe09134-90c3-4406-afe8-2bf93caaa7c0" />

<img width="300" alt="Lista" src="https://github.com/user-attachments/assets/ecfb88c1-ea9d-4540-8134-6addd6cb8396" />

<img width="300" alt="Vincular tarjeta" src="https://github.com/user-attachments/assets/98c97e3c-455e-40b8-b19a-a0bed429e9f5" />

<img width="300" alt="Error tarjeta" src="https://github.com/user-attachments/assets/64561ccd-71ea-409b-a3be-32fa41838101" />

<img width="300" alt="Error" src="https://github.com/user-attachments/assets/cac0babc-9364-4a48-942f-d7401e89197d" />

<img height="300" alt="Landscape" src="https://github.com/user-attachments/assets/390771f9-e501-4cf4-8ab1-7e009bf6bb54" />

<img height="300" alt="Simulator Screenshot - iPhone 17 Pro - 2026-02-01 at 23 12 17" src="https://github.com/user-attachments/assets/4c250510-4048-4b0b-890c-6009a82cab6f" />



