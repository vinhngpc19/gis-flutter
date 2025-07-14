// ignore: depend_on_referenced_packages
import 'package:collection/collection.dart';

class NumberValidator {
  static const malformed = '数字以外は入力できません。';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d+').hasMatch(value)) {
      return malformed;
    }

    return null;
  }
}

class TelValidator {
  static const malformed = '電話番号の形式が正しくありません。';
  static const containsConsecutiveHyphen = '-が連続で使われています。';
  static const containsFullNumber = '全角数字が含まれています';
  static const containsFullHyphen = 'ハイフン（-）は半角で入力してください';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^0[-\d]{11,12}$').hasMatch(value)) {
      return malformed;
    }

    if (RegExp(r'^0(?:-\d{4}){2,3}$').hasMatch(value)) {
      return containsConsecutiveHyphen;
    }

    if (RegExp(r'^[０-９]+').hasMatch(value)) {
      return containsFullNumber;
    }

    if (RegExp(r'ー').hasMatch(value)) {
      return containsFullHyphen;
    }

    return null;
  }
}

class ZipNoValidator {
  static const malformed = '郵便番号は000-0000の形式で入力してください';
  static const containsFullNumber = '全角数字が含まれています';
  static const containsFullHyphen = 'ハイフン（-）は半角で入力してください';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d{3}-\d{4}$').hasMatch(value)) {
      return malformed;
    }

    if (RegExp(r'^[０-９]+').hasMatch(value)) {
      return containsFullNumber;
    }

    if (RegExp(r'ー').hasMatch(value)) {
      return containsFullHyphen;
    }

    return null;
  }
}

class ZipNoReturnValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (RegExp(r'^\d{8}$').hasMatch(value)) {
      return '7桁以内を入力してください。';
    }

    return null;
  }
}

class KatakanaValidator {
  static const malformed = 'カタカナ以外は入力できません';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^[ァ-ヶー]+$').hasMatch(value)) {
      return malformed;
    }

    return null;
  }
}

class EmailValidator {
  static const containsBlank = '空文字が含まれています。';
  static const containsFullAtMark = '@が全角になっています。。';
  static const malformed = 'メールの形式が正しくありません。';
  static const containsConsecutiveDot = '.が連続で使われています。';
  static const dotAfterAtMark = '@の前に.があります。';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    // if (value.contains(' ')) {
    //   return containsBlank;
    // }

    if (value.contains('＠')) {
      return containsFullAtMark;
    }

    if (!RegExp(r'^[\w.-]+@[a-zA-Z\d]+\.[a-zA-Z]+$').hasMatch(value)) {
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

class DateTimeValidator {
  static const malformed = '日付の形式が正しくありません';

  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }

    if (!RegExp(r'^\d{4}年\d{2}月\d{2}日 \d{2}時\d{2}分$').hasMatch(value)) {
      return malformed;
    }

    return null;
  }
}
