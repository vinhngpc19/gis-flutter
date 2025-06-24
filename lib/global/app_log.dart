import 'package:flutter/foundation.dart';

class AppLog {
  static void dbPrint(dynamic mms) {
    if (!kReleaseMode) {
      debugPrint(mms);
    }
  }

  static void print(dynamic mms) {
    if (!kReleaseMode) {
      debugPrint(
          '====================================> $mms <====================================');
    }
  }
}
