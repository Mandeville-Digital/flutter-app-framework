# Mandeville App Framework

A Flutter application implementing clean architecture with the BLoC (Business Logic Component) pattern.

## Architecture Overview

The application follows a clean architecture approach with the BLoC pattern for state management:

```
lib/
├── features/           # Feature-based structure
│   ├── core/          # Core functionality shared across features
│   │   ├── events/    # Event system for analytics and cross-cutting concerns
│   │   ├── domain/    # Base domain entities and interfaces
│   │   ├── network/   # Network related code
│   │   └── repository/# Base repository interfaces
│   └── task/          # Example feature
│       ├── bloc/      # BLoC pattern implementation
│       ├── domain/    # Feature-specific entities
│       ├── repository/# Data access layer
│       └── presentation/
│           ├── screens/
│           ├── widgets/
│           └── routes/
└── config/            # App-wide configuration
```

## Key Concepts

### BLoC Pattern
- **Events**: Represent user actions or system events
- **States**: Represent the UI state at any given moment
- **BLoC**: Handles business logic and state transitions

### Dependency Injection
- Uses `get_it` for service location
- Dependencies are injected at the route level
- UI components receive dependencies via constructors

### Repository Pattern
- Abstracts data sources
- Provides clean interfaces for data operations
- Enables easy testing and data source switching

## Getting Started

1. Install dependencies:
```bash
flutter pub get
```

2. Run the app:
```bash
flutter run
```

## Development Guidelines

1. **Feature Organization**
   - Each feature has its own directory
   - Features are independent and self-contained
   - Shared code goes in the core feature

2. **State Management**
   - Use BLoC for complex state management
   - Keep UI components pure and focused on presentation
   - Handle business logic in BLoCs

3. **Dependency Injection**
   - Register services in feature registration files
   - Inject dependencies at route level
   - Keep UI components free of direct service locator usage

4. **Testing**
   - BLoCs are easily testable with clear event/state flows
   - Use constructor injection for easy mocking
   - Repository interfaces enable data layer mocking

## Contributing

1. Create a new feature directory following the existing structure
2. Implement BLoC pattern for state management
3. Follow the dependency injection guidelines
4. Add tests for BLoCs and repositories
5. Update documentation as needed
