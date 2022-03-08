import 'package:flutter/material.dart';
import 'package:marvel/ui/utils/colors.dart';

class LabelLink extends StatelessWidget {
  const LabelLink({
    required this.label,
    required this.onTap,
    this.alignment = MainAxisAlignment.start,
    this.padding,
  });

  final String label;
  final VoidCallback onTap;
  final MainAxisAlignment alignment;
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding ?? const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyText1?.copyWith(
                    fontSize: 14.0,
                    color: MarvelColors.primary,
                  ),
            ),
          ),
        ),
      ],
    );
  }
}
