import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/route_manager.dart';
import 'package:gis_disaster_flutter/common/helpers/snack_bar_helper.dart';
import 'package:url_launcher/url_launcher.dart';

double doubleInRange({required num start, required num end}) =>
    math.Random().nextDouble() * (end - start) + start;

int intInRange({required int min, required int max}) =>
    min + math.Random().nextInt(max - min);

class KeyboardLifecycleEventHandler extends WidgetsBindingObserver {
  KeyboardLifecycleEventHandler({required this.onKeyboardVisibilityChanged});
  final Function(bool) onKeyboardVisibilityChanged;

  @override
  void didChangeMetrics() {
    final bool keyboardVisible =
        // ignore: deprecated_member_use
        WidgetsBinding.instance.window.viewInsets.bottom > 0;
    onKeyboardVisibilityChanged(keyboardVisible);
  }
}

void copyText(String text) {
  Clipboard.setData(ClipboardData(text: text)).then((_) {
    SnackBarHelper.showMessage('コピーされました。');
  });
}

void openBrowser(path) {
  launchUrl(
    Uri.parse(path),
    mode: LaunchMode.externalApplication,
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
  );
}

void openBrowserInApp(path) {
  launchUrl(
    Uri.parse(path),
    mode: LaunchMode.inAppWebView,
    webOnlyWindowName: '',
    webViewConfiguration: const WebViewConfiguration(enableJavaScript: true),
  );
}

int? numberOfLines(TextStyle style, String text) {
  final Size sizeFull = (TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    textScaler: TextScaler.noScaling,
    textDirection: TextDirection.ltr,
  )..layout())
      .size;
  final numberOfLineBreak = text.split('\n').length;
  final numberOfLine = sizeFull.width / (Get.width - 92);
  final int numberOfLines = numberOfLine.round() + numberOfLineBreak;
  return numberOfLines;
}

String parseDateFromDotNetString(String? input,
    {String format = 'dd/MM/yyyy HH:mm'}) {
  if (input == null || input.isEmpty) return '';
  final reg = RegExp(r"/Date\((\d+)\)/");
  final match = reg.firstMatch(input);
  if (match != null && match.groupCount > 0) {
    final millis = int.tryParse(match.group(1)!);
    if (millis != null) {
      final dt = DateTime.fromMillisecondsSinceEpoch(millis);
      return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
    }
  }
  return input;
}
