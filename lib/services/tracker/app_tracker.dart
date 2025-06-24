class AppUsageTracker {
  final Stopwatch _stopwatch = Stopwatch();

  void startTracking() {
    if (!_stopwatch.isRunning) {
      _stopwatch.start();
    }
  }

  void stopTracking() {
    if (_stopwatch.isRunning) {
      _stopwatch.stop();
      _stopwatch.reset();
    }
  }

  void sendUsageTimeToApi() {
    if (_stopwatch.elapsed.inMinutes > 0) {
      // Here you would typically send the data to server
    }
    stopTracking();
  }
}
