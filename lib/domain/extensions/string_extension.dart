extension StringExtension on String {
  bool isValidMail() {
    if (isEmpty) return false;

    // ignore: unnecessary_string_escapes
    const String p = '[a-zA-Z0-9\+\.\_\%\-\+]{1,256}'
        '\\@'
        '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}'
        '('
        '\\.'
        '[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}'
        ')+';
    final regExp = RegExp(p);

    return regExp.hasMatch(this);
  }
}
