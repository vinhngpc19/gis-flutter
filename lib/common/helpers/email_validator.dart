// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class EmailValidator {
  static const isEmpty = 'アドレスが未設定です。';
  static const containsBlank = '空文字が含まれています。';
  static const containsFullAtMark = '@が全角になっています。。';
  static const malformed = 'メールの形式が正しくありません。';
  static const containsConsecutiveDot = '.が連続で使われています。';
  static const dotAfterAtMark = '@の前に.があります。';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return isEmpty;
    }

    if (value.contains(' ')) {
      return containsBlank;
    }

    if (value.contains('＠')) {
      return containsFullAtMark;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+")
        .hasMatch(value)) {
      return malformed;
    }

    if (value.split('.').contains('')) {
      return containsConsecutiveDot;
    }

    if (value.split('.').firstWhereOrNull((e) => e.startsWith('@')) != null) {
      return dotAfterAtMark;
    }

    return null;
  }
}

class PasswordValidator {
  static const isEmpty = '未入力です';
  static const containsBlank = '空文字が含まれています。';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return isEmpty;
    }

    if (value.contains(' ')) {
      return containsBlank;
    }

    return null;
  }
}
