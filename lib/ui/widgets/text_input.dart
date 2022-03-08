import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marvel/ui/utils/colors.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

enum TextInputLabBorder {
  normal,
  circular,
}

class TextInputLab extends StatefulWidget {
  const TextInputLab({
    Key? key,
    required this.hintText,
    this.borderRadius = TextInputLabBorder.normal,
    this.controller,
    this.inputFormatters,
    this.maxLength,
    this.labelText,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword = false,
    this.enabled = true,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextInputLabBorder borderRadius;
  final int? maxLength;

  /// If this is true, it will be rendered a suffixIcon to control whether or
  /// not the password mus be shown.
  final bool isPassword;
  final bool enabled;
  final String hintText;
  final String? labelText;
  final String? errorText;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final TextInputType keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  bool get isNormalBorder => borderRadius == TextInputLabBorder.normal;

  @override
  _TextInputLabState createState() => _TextInputLabState();
}

class _TextInputLabState extends State<TextInputLab> {
  bool _showValue = false;

  @override
  Widget build(BuildContext context) {
    Widget? suffixIcon =
        widget.suffixIcon != null ? Icon(widget.suffixIcon) : null;
    if (suffixIcon == null && widget.isPassword) {
      suffixIcon = _buildShowValueButton();
    }

    Widget? prefixIcon;
    if (widget.prefixIcon != null) {
      prefixIcon = Icon(widget.prefixIcon);
    }

    final borderRadius = widget.isNormalBorder
        ? const BorderRadius.all(Radius.circular(10))
        : const BorderRadius.all(Radius.circular(50));
    final border = OutlineInputBorder(
      borderSide: const BorderSide(color: MarvelColors.border),
      borderRadius: borderRadius,
    );

    final errorBorder = OutlineInputBorder(
      borderSide: const BorderSide(color: MarvelColors.redError),
      borderRadius: borderRadius,
    );

    return TextField(
      controller: widget.controller,
      enabled: widget.enabled,
      maxLength: widget.maxLength,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      obscureText: widget.isPassword && !_showValue,
      cursorColor: MarvelColors.primary,
      inputFormatters: widget.inputFormatters,
      style: TextStyle(
        color: widget.enabled ? MarvelColors.black : MarvelColors.hintText,
      ),
      decoration: InputDecoration(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        filled: true,
        fillColor: MarvelColors.white,
        labelText: widget.labelText,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        border: border,
        enabledBorder: border,
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: MarvelColors.hintText,
          fontStyle: FontStyle.italic,
          fontSize: 14.0,
        ),
        errorStyle: const TextStyle(color: MarvelColors.redError),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: widget.errorText,
        errorMaxLines: 2,
      ),
    );
  }

  Widget _buildShowValueButton() {
    return IconButton(
      icon: _showValue ? const Icon(MdiIcons.eye) : const Icon(MdiIcons.eyeOff),
      onPressed: () {
        setState(() {
          _showValue = !_showValue;
        });
      },
    );
  }
}
