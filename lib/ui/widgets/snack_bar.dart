import 'package:flutter/material.dart';
import 'package:marvel/ui/utils/colors.dart';

enum SnackBarType { error, info }

void showSnackBar(
  BuildContext context, {
  required SnackBarType type,
  required String? text,
}) {
  final snackBar = _buildSnackBar(context, type: type, text: text ?? '');

  final scaffoldMessenger = ScaffoldMessenger.of(context);
  scaffoldMessenger.hideCurrentSnackBar();
  scaffoldMessenger.showSnackBar(snackBar);
}

SnackBar _buildSnackBar(
  BuildContext context, {
  required SnackBarType type,
  required String text,
}) {
  Color backgroundColor;
  switch (type) {
    case SnackBarType.error:
      backgroundColor = MarvelColors.redError;
      break;
    case SnackBarType.info:
      backgroundColor = MarvelColors.white;
      break;
  }

  return SnackBar(
    backgroundColor: backgroundColor,
    content: Text(
      text,
      style: Theme.of(context).snackBarTheme.contentTextStyle?.copyWith(
            fontSize: 16.0,
            color: MarvelColors.white,
          ),
    ),
  );
}
