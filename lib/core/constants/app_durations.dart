/// App-wide duration and animation timing constants
class AppDurations {
  AppDurations._();

  // Standard Durations
  static const Duration instant = Duration(milliseconds: 0);
  static const Duration veryFast = Duration(milliseconds: 100);
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 400);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration verySlow = Duration(milliseconds: 800);

  // Animation Durations
  static const Duration fadeIn = Duration(milliseconds: 300);
  static const Duration fadeOut = Duration(milliseconds: 200);
  static const Duration slideIn = Duration(milliseconds: 300);
  static const Duration scaleUp = Duration(milliseconds: 200);
  static const Duration progressAnimation = Duration(milliseconds: 600);

  // Typing Indicator
  static const Duration typingDelay = Duration(milliseconds: 800);
  static const Duration messageDelay = Duration(milliseconds: 500);
  static const Duration botResponseDelay = Duration(milliseconds: 1500);

  // Scroll
  static const Duration scrollAnimation = Duration(milliseconds: 300);

  // Loading & Debounce
  static const Duration debounce = Duration(milliseconds: 500);
  static const Duration loadingMin = Duration(milliseconds: 1000);
  static const Duration timeout = Duration(seconds: 30);

  // Snackbar
  static const Duration snackbarShort = Duration(seconds: 2);
  static const Duration snackbarNormal = Duration(seconds: 3);
  static const Duration snackbarLong = Duration(seconds: 5);

  // Refresh
  static const Duration refreshDelay = Duration(milliseconds: 500);
  static const Duration refreshDuration = Duration(milliseconds: 1000);
}
