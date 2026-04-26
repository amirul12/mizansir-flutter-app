import 'logger.dart';

// Initialize logger for testing/debugging
final _log = logger(AmirDebug);

// Class marker for logger identification
class AmirDebug {}

/// Debug print function that uses logger for consistent output formatting
/// This function will only print in debug mode
void amirPrint(var data) {
  // Check if we're in debug mode
  if (const bool.fromEnvironment('dart.vm.product')) {
    // In production/release mode, do nothing
    return;
  }

  // In debug mode, log the data
  if (data != null) {
    _log.d(data.toString());
  } else {
    _log.d('null');
  }
}
