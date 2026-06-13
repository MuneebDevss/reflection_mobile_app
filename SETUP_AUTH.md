# Quick Setup Guide - JWT Authentication

## Installation Steps

### 1. Install Dependencies

The required dependencies are already added to `pubspec.yaml`. Run:

```bash
cd reflection_frontend
flutter pub get
```

### 2. Backend Configuration

Make sure your NestJS backend is running and accessible. The Flutter app is configured to connect to:

```
https://reflection-backend-qq5u.onrender.com
```

To change the backend URL, update:
- `lib/data/services/auth_service.dart` - line 21
- `lib/data/services/goal_api_service.dart` - line 20

```dart
static const String baseUrl = 'YOUR_BACKEND_URL';
```

### 3. Run the App

```bash
flutter run
```

The app will automatically show the login screen on first launch.

## Adding Logout to Existing Screens

To add user menu with logout functionality to any screen, simply add the `UserMenuWidget` to the AppBar actions:

### Example: Update MyGoalsView

**File:** `lib/features/goals/view/my_goals_view.dart`

Add the import at the top:
```dart
import '../../auth/widgets/user_menu_widget.dart';
```

Then update the AppBar actions:

```dart
appBar: AppBar(
  title: const Text(
    AppStrings.myGoalsTitle,
    style: TextStyle(
      fontSize: AppSizes.fontDisplay1,
      fontWeight: FontWeight.w700,
      color: AppColors.textWhite,
      letterSpacing: AppSizes.letterSpacingNormal,
    ),
  ),
  backgroundColor: AppColors.primaryPurple,
  elevation: AppSizes.appBarElevation,
  actions: [
    // Add this line for user menu with logout
    const UserMenuWidget(),
    
    // Existing refresh button
    IconButton(
      icon: const Icon(Icons.refresh_rounded, color: AppColors.textWhite),
      onPressed: () {
        ref
            .read(myGoalsViewModelProvider(userId).notifier)
            .refreshGoals();
      },
    ),
    const SizedBox(width: AppSizes.spaceS),
  ],
),
```

### Alternative: Custom Logout Button

If you prefer a custom logout button:

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/providers.dart';
import '../../auth/view/login_screen.dart';

// In your widget:
IconButton(
  icon: const Icon(Icons.logout),
  onPressed: () async {
    // Logout
    await ref.read(authViewModelProvider.notifier).logout();
    
    // Navigate to login
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  },
)
```

## Testing Checklist

### ✅ Registration Flow
1. Launch app → Should show Login screen
2. Click "Sign Up"
3. Enter email, password, name (optional)
4. Click "Create Account"
5. Should navigate to Goals screen automatically
6. User avatar should appear in app bar (if UserMenuWidget added)

### ✅ Login Flow
1. Launch app → Login screen
2. Enter registered email and password
3. Click "Sign In"
4. Should navigate to Goals screen
5. Token saved securely

### ✅ Auto-Login
1. Login successfully
2. Close app completely (kill process)
3. Reopen app
4. Should automatically go to Goals screen (skip login)

### ✅ Logout Flow
1. While logged in, click user avatar
2. Click "Logout"
3. Confirm in dialog
4. Should navigate to Login screen
5. Token cleared

### ✅ API with JWT
1. Login successfully
2. Create a new goal
3. Check backend logs - should see JWT token in Authorization header
4. Goal should be created successfully

### ✅ Error Handling
1. Try logging in with wrong password → Shows error snackbar
2. Try registering with existing email → Shows conflict error
3. Try with no internet → Shows network error

## Common Issues & Solutions

### Issue: "Cannot connect to backend"
**Solution:** 
- Check backend is running
- Verify backend URL in auth_service.dart and goal_api_service.dart
- Check CORS settings on backend

### Issue: "flutter_secure_storage not working on Android"
**Solution:** 
- Make sure Android minSdkVersion is at least 18
- Check android/app/build.gradle

### Issue: "Token not persisting"
**Solution:**
- Check flutter_secure_storage permissions
- On iOS: Check Keychain access
- On Android: Check storage permissions

### Issue: "User menu not showing"
**Solution:**
- Make sure you imported UserMenuWidget
- Add it to AppBar actions array
- Check auth state is authenticated

## Key Files Reference

| File | Purpose |
|------|---------|
| `lib/data/services/auth_service.dart` | API calls for auth |
| `lib/features/auth/viewmodel/auth_viewmodel.dart` | Auth business logic |
| `lib/features/auth/state/auth_state.dart` | Auth state definition |
| `lib/features/auth/view/login_screen.dart` | Login UI |
| `lib/features/auth/view/register_screen.dart` | Register UI |
| `lib/features/auth/widgets/user_menu_widget.dart` | Logout menu |
| `lib/providers/providers.dart` | Riverpod providers |
| `lib/main.dart` | Auth routing |

## Environment-Specific Configuration

For different environments (dev, staging, prod), update base URLs:

```dart
// Option 1: Compile-time constants
class AppConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_URL',
    defaultValue: 'https://reflection-backend-qq5u.onrender.com',
  );
}

// Run with:
// flutter run --dart-define=API_URL=http://localhost:3001

// Option 2: Runtime configuration
class Environment {
  static const isProduction = bool.fromEnvironment('dart.vm.product');
  
  static String get baseUrl {
    if (isProduction) {
      return 'https://reflection-backend-qq5u.onrender.com';
    }
    return 'http://localhost:3001';
  }
}
```

## Platform-Specific Notes

### iOS
- flutter_secure_storage uses Keychain
- Requires iOS 11.0+
- Auto-configured, no extra setup needed

### Android
- Uses EncryptedSharedPreferences
- Requires minSdkVersion 18+
- Already configured in pubspec.yaml

### Web
- Uses localStorage with encryption
- Not as secure as native platforms
- Consider additional security measures for web

### Desktop (Windows, macOS, Linux)
- Supported by flutter_secure_storage
- Uses OS-level secure storage
- Same API as mobile

## Next Steps

1. **Add UserMenuWidget to all screens**
   - Update MyGoalsView
   - Update GoalDetailsView
   - Update any other screens with AppBar

2. **Test thoroughly**
   - Test on real devices
   - Test network failures
   - Test token expiration

3. **Consider enhancements**
   - Add biometric authentication
   - Add password reset flow
   - Add profile editing
   - Add token refresh mechanism

4. **Monitor in production**
   - Track login success rate
   - Monitor authentication errors
   - Check token expiration issues

---

**Quick Commands:**
```bash
# Install dependencies
flutter pub get

# Run app
flutter run

# Run on specific device
flutter run -d chrome     # Web
flutter run -d ios        # iOS Simulator
flutter run -d android    # Android Emulator

# Check for errors
flutter analyze

# Clean and rebuild
flutter clean && flutter pub get && flutter run
```

Need help? Check [AUTH_IMPLEMENTATION.md](AUTH_IMPLEMENTATION.md) for comprehensive documentation.
