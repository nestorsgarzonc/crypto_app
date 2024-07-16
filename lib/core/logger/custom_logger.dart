import 'dart:developer' as dev;

class Logger {
  const Logger({required this.name});

  final String name;

  static void log(String message,
      {String name = 'CryptoApp', Object? error, StackTrace? stackTrace}) {
    dev.log(
      message,
      name: name,
      error: error,
      stackTrace: stackTrace,
    );
  }

  void info(String message) {
    log(message, name: name);
  }

  void error(String message, Object error, StackTrace stackTrace) {
    log(message, name: name, error: error, stackTrace: stackTrace);
  }

  void warning(String message) {
    log(message, name: name);
  }

  void debug(String message) {
    log(message, name: name);
  }
}
