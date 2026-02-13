# JWT Authentication Implementation - Flutter

## ✅ Implementation Complete

JWT-based authentication has been successfully integrated into the Reflection Flutter app.

## What Was Implemented

### 1. **Dependencies Added**
```yaml
dependencies:
  flutter_secure_storage: ^9.2.2  # For secure JWT token storage

existing:
  flutter_riverpod: ^2.6.1        # State management
  http: ^1.2.0                    # API calls
```

### 2. **Project Structure**

```
lib/
├── data/
│   ├── models/
│   │   └── user.dart              # User, AuthResponse, Login/Register DTOs
│   └── services/
│       ├── auth_service.dart      # Authentication API service
│       └── goal_api_service.dart  # Updated with JWT support
├── features/
│   └── auth/
│       ├── state/
│       │   └── auth_state.dart    # Authentication state management
│       ├── viewmodel/
│       │   └── auth_viewmodel.dart # Auth business logic
│       ├── view/
│       │   ├── login_screen.dart   # Login UI
│       │   └── register_screen.dart # Registration UI
│       └── widgets/
│           └── user_menu_widget.dart # Logout menu widget
├── providers/
│   └── providers.dart             # Updated with auth provider
└── main.dart                      # Updated with auth routing
```

### 3. **Features**

#### ✅ **Authentication Service**
- Register new users with email/password
- Login with existing credentials
- Secure JWT token storage using `flutter_secure_storage`
- Auto-login on app restart
- Token management with Bearer authentication
- Logout functionality

#### ✅ **State Management (Riverpod)**
- `AuthState` with statuses:
  - `initial` - Checking authentication on startup
  - `loading` - During login/register operations
  - `authenticated` - User is logged in
  - `unauthenticated` - User is logged out
- `AuthViewModel` for managing auth operations
- Global auth provider accessible throughout the app

#### ✅ **UI Screens**

**Login Screen:**
- Email validation
- Password validation (minimum 6 characters)
- Password visibility toggle
- Loading indicator during authentication
- Error messages via snackbar
- Navigation to register screen
- Clean, Material 3 design

**Register Screen:**
- Name field (optional)
- Email validation
- Password validation
- Confirm password validation
- Password visibility toggles
- Loading indicator
- Error handling
- Navigation back to login

#### ✅ **API Integration**
- All `GoalApiService` methods updated to include JWT tokens
- Authorization header: `Bearer <token>`
- Automatic token injection for authenticated requests
- Backward compatible (optional auth)

#### ✅ **Auto-Login**
- App checks for saved JWT token on startup
- Automatically logs in if valid token exists
- Redirects to home screen if authenticated
- Shows login screen if not authenticated

#### ✅ **Navigation Flow**
```
App Start
    ↓
Check Auth Status (AuthWrapper)
    ↓
    ├─→ Authenticated → Home Screen (MyGoalsView)
    └─→ Not Authenticated → Login Screen
```

### 4. **Security Features**

✅ **Secure Storage:**
- JWT tokens stored using `flutter_secure_storage`
- Platform-level encryption (Keychain on iOS, Keystore on Android)

✅ **Password Security:**
- Passwords never stored locally
- Always transmitted to backend for hashing
- Password validation before submission

✅ **Token Management:**
- Tokens automatically included in API requests
- No manual token handling required
- Secure token retrieval from storage

### 5. **User Experience**

✅ **Loading States:**
- Circular progress indicator during operations
- Disabled buttons while loading
- Responsive UI

✅ **Error Handling:**
- User-friendly error messages
- Network error handling
- API error messages displayed
- Automatic error clearing after display

✅ **Form Validation:**
- Email format validation
- Password length validation
- Password match confirmation
- Real-time validation feedback

## How to Use

### **Navigation & Routing**

The app automatically handles authentication routing:

```dart
// main.dart - No changes needed
void main() {
  runApp(const ProviderScope(child: MyApp()));
}

// AuthWrapper handles authentication state automatically
// Shows login or home based on authentication status
```

### **Using Auth State in Widgets**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflection_frontend/providers/providers.dart';

class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch auth state
    final authState = ref.watch(authViewModelProvider);
    
    // Check if authenticated
    if (authState.isAuthenticated) {
      final userId = authState.user!.id;
      final email = authState.user!.email;
      final name = authState.user?.name;
      
      // Use user data
    }
    
    // Check loading state
    if (authState.isLoading) {
      return CircularProgressIndicator();
    }
    
    return Container();
  }
}
```

### **Adding Logout to Your Screens**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reflection_frontend/features/auth/widgets/user_menu_widget.dart';

class MyGoalsView extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Goals'),
        actions: [
          // Add user menu with logout option
          UserMenuWidget(),
        ],
      ),
      body: ...,
    );
  }
}
```

### **Manual Logout**

```dart
// Logout programmatically
ref.read(authViewModelProvider.notifier).logout();

// Navigate to login
Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (_) => LoginScreen()),
);
```

### **Accessing Current User**

```dart
// Get current user anywhere in the app
final authState = ref.watch(authViewModelProvider);
final user = authState.user;

if (user != null) {
  print('User ID: ${user.id}');
  print('Email: ${user.email}');
  print('Name: ${user.name ?? "No name"}');
}
```

## API Configuration

The authentication service connects to your NestJS backend:

```dart
// lib/data/services/auth_service.dart
static const String baseUrl = 'https://reflection-backend-qq5u.onrender.com';

// Endpoints:
// POST /auth/register - Register new user
// POST /auth/login    - Login existing user
```

### **API Request Format**

**Register:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "John Doe"  // optional
}
```

**Login:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:**
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2026-02-13T...",
    "updatedAt": "2026-02-13T..."
  },
  "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

## Testing

### **Test Registration**
1. Run the app: `flutter run`
2. Click "Sign Up" on login screen
3. Fill in email, password, and optionally name
4. Click "Create Account"
5. Should navigate to home screen automatically

### **Test Login**
1. Click "Sign In" from register screen
2. Enter email and password
3. Click "Sign In"
4. Should navigate to home screen

### **Test Auto-Login**
1. Login successfully
2. Close the app completely
3. Reopen the app
4. Should automatically navigate to home screen (no login needed)

### **Test Logout**
1. While logged in, click avatar in app bar
2. Click "Logout"
3. Confirm logout
4. Should navigate to login screen

### **Test Token in API Calls**
All goal-related API calls now automatically include JWT token:
```dart
// Before (no auth):
final goals = await goalApiService.getGoals(userId);

// After (automatic JWT):
final goals = await goalApiService.getGoals(userId); // Same call, JWT auto-added
```

## Error Handling

### **Common Errors**

**401 Unauthorized:**
- Invalid credentials
- Expired token
- Solution: Login again

**409 Conflict:**
- Email already exists
- Solution: Use different email or login

**Network Error:**
- No internet connection
- Backend unavailable
- Solution: Check connectivity

## State Flow Diagram

```
┌─────────────────────────────────────────────────┐
│                   App Start                     │
└───────────────────┬─────────────────────────────┘
                    │
                    ↓
┌─────────────────────────────────────────────────┐
│    AuthViewModel.checkAuthStatus()              │
│    Check if JWT token exists                    │
└───────────────────┬─────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
        ↓                       ↓
┌───────────────┐      ┌────────────────┐
│ Token Exists  │      │  No Token      │
│ User Valid    │      │                │
└───────┬───────┘      └────────┬───────┘
        │                       │
        ↓                       ↓
┌───────────────┐      ┌────────────────┐
│ State:        │      │ State:         │
│ Authenticated │      │ Unauthenticated│
│               │      │                │
│ Navigate to:  │      │ Show:          │
│ Home Screen   │      │ Login Screen   │
└───────────────┘      └────────┬───────┘
                                │
                    ┌───────────┴──────────┐
                    │                      │
                    ↓                      ↓
        ┌──────────────────┐   ┌──────────────────┐
        │  User Registers  │   │   User Logs In   │
        └────────┬─────────┘   └────────┬─────────┘
                 │                      │
                 └──────────┬───────────┘
                            │
                            ↓
                ┌───────────────────────┐
                │  JWT Token Saved      │
                │  State: Authenticated │
                │  Navigate to Home     │
                └───────────────────────┘
```

## Breaking Changes

❌ **None!** All existing functionality preserved.

✅ **What Wasn't Changed:**
- Existing UI screens (goals, tasks, details)
- Existing API services (only JWT support added)
- Existing state management structure
- Existing design system/colors
- Existing navigation (except auth routing)

## Next Steps (Optional Enhancements)

Consider implementing:
- [ ] Refresh token mechanism
- [ ] Token expiration handling with auto-refresh
- [ ] Remember me checkbox
- [ ] Password reset flow
- [ ] Email verification
- [ ] Biometric authentication (fingerprint/face)
- [ ] Social login (Google, Apple)
- [ ] Profile editing
- [ ] Change password functionality

## Architecture Benefits

✅ **Clean Separation:**
- Auth logic isolated in dedicated feature folder
- Reusable auth provider via Riverpod
- No tight coupling with existing features

✅ **Maintainable:**
- Clear file structure
- Single responsibility principle
- Easy to extend

✅ **Testable:**
- ViewModel separates business logic from UI
- Service layer can be mocked
- State management with Riverpod

✅ **Scalable:**
- Easy to add new auth methods
- Simple to add auth to new screens
- Prepared for multi-platform (iOS, Android, Web)

---

**Implementation Date:** February 13, 2026  
**Status:** Complete and Ready for Testing  
**Compatibility:** Flutter 3.x, Dart 3.x
