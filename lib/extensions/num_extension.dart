import 'dart:async';

/// Extends the functionality of the `num` class by adding various methods for formatting and working with numbers.
extension NumEx on num {
  /// Adds a suffix to the number.
  ///
  /// This method takes an optional parameter [suffix],
  /// which is a string that will be appended to the number.
  /// If [suffix] is not provided, it defaults to an ordinal suffix (e.g. 1st, 2nd, 3rd, etc.).
  ///
  /// Example usage:
  /// ```dart
  ///   print(5.suffix()); // prints "5th"
  ///   print(5.suffix('%')); // prints "5%"
  /// ```

  String suffix([String suffix = '']) {
    if (suffix.isNotEmpty) {
      return '$this$suffix';
    }
    switch (this % 100) {
      case 11:
      case 12:
      case 13:
        return '${this}th';
      default:
        switch (this % 10) {
          case 1:
            return '${this}st';
          case 2:
            return '${this}nd';
          case 3:
            return '${this}rd';
          default:
            return '${this}th';
        }
    }
  }

  /// Returns a `Duration` object representing the number of seconds represented by this number.
  ///
  /// Example usage:
  /// ```dart
  ///   var fiveSeconds = 5.seconds;
  ///   print(fiveSeconds); // prints "Duration: 00:00:05.000000"
  /// ```
  // Duration get seconds => Duration(seconds: this as int);

  /// Returns a `Duration` object representing the number of milliseconds represented by this number.
  ///
  /// Example usage:
  /// ```dart
  ///   var fiveMilliseconds = 5.milliseconds;
  ///   print(fiveMilliseconds); // prints "Duration: 0:00:00.005000"
  /// ```
  Duration get milliseconds => Duration(milliseconds: this as int);

  /// Returns a `Duration` object representing the number of microseconds represented by this number.
  ///
  /// Example usage:
  /// ```dart
  ///   var fiveMicroseconds = 5.microseconds;
  ///   print(fiveMicroseconds); // prints "Duration: 0:00:00.000005"
  /// ```
  Duration get microseconds => Duration(microseconds: this as int);

  /// Returns a `Duration` object representing the number of minutes represented by this number.
  ///
  /// Example usage:
  /// ```dart
  ///   var fiveMinutes = 5.minutes;
  ///   print(fiveMinutes); // prints "Duration: 0:05:00.000000"
  /// ```
  Duration get minutes => Duration(minutes: this as int);

  /// Returns a `Duration` object representing the number of hours represented by this number.
  ///
  /// Example usage:
  /// ```dart
  ///   var fiveHours = 5.hours;
  ///   print(fiveHours); // prints "Duration: 5:00:00.000000"
  /// ```
  Duration get hours => Duration(hours: this as int);

  /// Returns a `Duration` object representing the number of days represented by this number.
  ///
  /// Example usage:
  /// ```dart
  ///   var fiveDays = 5.days;
  ///   print(fiveDays); // prints "Duration: 120:00:00.000000"
  /// ```
  Duration get days => Duration(days: this as int);

  /// Delays the execution of a callback or code block by the specified number of seconds.
  ///
  /// The [callback] parameter is an optional function that will be executed after
  /// the specified delay. If provided, it will be called asynchronously once the
  /// delay has completed.
  ///
  /// Example:
  /// ```dart
  /// void main() async {
  ///   print('+ wait for 2 seconds');
  ///   await 2.delay();
  ///   print('- 2 seconds completed');
  ///   print('+ callback in 1.2sec');
  ///   1.delay(() => print('- 1.2sec callback called'));
  ///   print('currently running callback 1.2sec');
  /// }
  ///```
  ///
  /// The above example waits for 2 seconds before printing '- 2 seconds completed'.
  /// It then waits for an additional 1.2 seconds before executing the callback
  /// that prints '- 1.2sec callback called'. Finally, it prints 'currently running
  /// callback 1.2sec'.
  Future delay([FutureOr Function()? callback]) async {
    final completer = Completer<void>();
    Timer(Duration(milliseconds: (this * 1000).round()), () {
      if (!completer.isCompleted) {
        completer.complete();
        callback?.call();
      }
    });
    return completer.future;
  }
}
