import 'dart:collection';
import 'dart:io';
import 'dart:math';

import 'package:android_id/android_id.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_utils/src/platform/platform.dart';
// import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

String generateRandomString(int length) {
  final r = Random();
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  return List.generate(length, (index) => chars[r.nextInt(chars.length)])
      .join();
}

// Future<bool?> allowPushFlag() async {
//   final PermissionStatus status = await Permission.notification.status;
//   if (status.isDenied || status.isPermanentlyDenied) {
//     return false;
//   } else {
//     return true;
//   }
// }

Future<String?> getDeviceId() async {
  if (GetPlatform.isIOS) {
    final deviceInfoPlugin = DeviceInfoPlugin();
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return iosInfo.identifierForVendor;
  } else {
    return await const AndroidId().getId();
  }
}

// Future<String> getAppVersion() async {
//   final PackageInfo packageInfo = await PackageInfo.fromPlatform();
//   return packageInfo.version;
// }

Future<String> getVersionOS() async {
  final deviceInfoPlugin = DeviceInfoPlugin();
  if (GetPlatform.isIOS) {
    final iosInfo = await deviceInfoPlugin.iosInfo;
    return 'IOS ${iosInfo.systemVersion}';
  } else {
    final androidInfo = await deviceInfoPlugin.androidInfo;
    return 'Android ${androidInfo.version.release}';
  }
}

dynamic valueNullOrEmpty(dynamic x) {
  return x != null && x.toString().isNotEmpty ? x : null;
}

String stringNullOrEmpty(dynamic x) {
  return x != null && x.toString().isNotEmpty ? x : '';
}

bool isNullOrEmpty(dynamic x) {
  assert(x == null ||
      x is String ||
      x is List ||
      x is Map ||
      x is HashMap ||
      x is Set);

  if (x == null) {
    return true;
  }

  if (x is String) {
    return x.isEmpty;
  }

  if (x is List) {
    return x.isEmpty;
  }

  if (x is Map) {
    return x.isEmpty;
  }

  if (x is HashMap) {
    return x.isEmpty;
  }

  if (x is Set) {
    return x.isEmpty;
  }

  return true;
}

bool isNotNullOrEmpty(dynamic x) {
  assert(x == null ||
      x is String ||
      x is List ||
      x is Map ||
      x is HashMap ||
      x is Set);

  if (x == null) {
    return false;
  }

  if (x is String) {
    return x.isNotEmpty;
  }

  if (x is List) {
    return x.isNotEmpty;
  }

  if (x is Map) {
    return x.isNotEmpty;
  }

  if (x is HashMap) {
    return x.isNotEmpty;
  }

  if (x is Set) {
    return x.isNotEmpty;
  }

  return false;
}

bool isNull(dynamic x) {
  return x == null;
}

bool isNotNull(dynamic x) {
  return x != null;
}

bool rejectIfEqual(List<bool> x) {
  for (final bool xx in x) {
    if (xx) {
      return false;
    }
  }

  return true;
}

DateTime dayTime() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
}

DateTime dayTimeAdd() {
  final now = DateTime.now().add(const Duration(days: 1));
  return DateTime(now.year, now.month, now.day, 0, 0, 0, 0, 0);
}

class RxNullable<T> {
  Rx<T> setNull() => (null as T).obs;
}

mixin AppCloser {
  void closeApp() {
    SystemChannels.platform.invokeMethod('SystemNavigator.pop');
  }
}
double getSizeOfWidget(GlobalKey key) {
  final RenderBox renderBox =
      key.currentContext!.findRenderObject()! as RenderBox;
  final Size size = renderBox.size;
  return size.height;
}

double getPositionOfWidget(GlobalKey key, bool firstValidate) {
  final RenderBox renderBox =
      key.currentContext!.findRenderObject()! as RenderBox;
  final targetPosition = renderBox.localToGlobal(Offset.zero);
  final targetSize = renderBox.size;
  final Rect rect = targetPosition & targetSize;

  return rect.top - (firstValidate ? rect.height + 30 : rect.height + 56);
}

int ceilMessagePage(count) {
  final int temp = (count / 20).ceil();
  return count % 20 == 0 ? temp + 1 : temp;
}

int limitMessage(count) {
  return (20 + (count % 20)).toInt();
}

Future<bool> allowLocation() async {
  await Permission.location.request();
  final PermissionStatus status = await Permission.location.status;
  if (status.isPermanentlyDenied || status.isDenied) {
    return false;
  } else {
    return true;
  }
}

Future<bool> allowCamera() async {
  await Permission.camera.request();
  final PermissionStatus status = await Permission.camera.status;
  if (status.isPermanentlyDenied || status.isDenied) {
    return false;
  } else {
    return true;
  }
}

Future<dio.MultipartFile> multipartFile(File imageFile) async {
  return await dio.MultipartFile.fromFile(
    imageFile.path,
    filename: imageFile.path.split('/').last,
  );
}

extension ListExtensions<T> on List<T> {
  Iterable<T> whereWithIndex(bool Function(T element, int index) test) {
    final List<T> result = [];
    for (var i = 0; i < length; i++) {
      if (test(this[i], i)) {
        result.add(this[i]);
      }
    }
    return result;
  }
}
