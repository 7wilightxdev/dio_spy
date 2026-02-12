# DioSpy Example

This example demonstrates how to use the `dio_spy` package to inspect HTTP requests and responses in a Flutter application.

## Overview

The example app makes various HTTP calls to the [FakeRESTApi](https://fakerestapi.azurewebsites.net/) to demonstrate:

- **GET requests** - Fetching lists and individual items
- **POST requests** - Creating new resources
- **PUT requests** - Updating existing resources
- **DELETE requests** - Removing resources
- **Error handling** - Displaying errors (e.g., 404 responses)
- **Shake gesture** - Opening the HTTP inspector by shaking the device

## Features Demonstrated

### API Endpoints Used

1. **Activities** - CRUD operations on activities
2. **Books** - CRUD operations on books
3. **Users** - Create and fetch users
4. **Authors** - Fetch authors and filter by book
5. **Error Testing** - Invalid endpoint to demonstrate error capturing

### DioSpy Features

- ✅ Automatic capture of all HTTP requests/responses
- ✅ Shake gesture to open inspector
- ✅ View request details (headers, body, cookies, query params)
- ✅ View response details (status, headers, body, size)
- ✅ JSON viewer with collapsible tree
- ✅ Copy to clipboard functionality
- ✅ Export as cURL command
- ✅ Filter by HTTP method
- ✅ Request/response timing

## Getting Started

### 1. Install Dependencies

```bash
cd example
flutter pub get
```

### 2. Run the App

```bash
flutter run
```

### 3. Make API Calls

- Tap any button in the app to make an HTTP request
- The response will be displayed at the bottom of the screen
    - All requests are captured by DioSpy

### 4. Open the HTTP Inspector

**Method 1: Shake Gesture**
- Shake your device (physical device only)
- The HTTP inspector will open automatically

**Method 2: Programmatically** (if you want to add a button)
```dart
// Add this to your code:
_dioSpy.show();
```

### 5. Inspect HTTP Calls

In the inspector, you can:
- View all captured HTTP calls
- Filter by method (GET, POST, PUT, DELETE)
- Tap a call to see detailed request/response information
- Copy request/response data
- Copy as cURL command
- See request duration and response size

## Code Structure

```
example/
├── lib/
│   ├── main.dart              # App entry point, DioSpy setup
│   ├── api_service.dart       # API service with all endpoints
│   └── screens/
│       └── home_screen.dart   # Main UI with API call buttons
├── pubspec.yaml               # Dependencies
└── README.md                  # This file
```