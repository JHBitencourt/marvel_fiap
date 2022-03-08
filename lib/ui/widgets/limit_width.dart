import 'package:flutter/material.dart';

const double maxWidthContent = 550;

class LimitWidth extends StatelessWidget {
  const LimitWidth({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        constraints: const BoxConstraints(
          maxWidth: maxWidthContent,
        ),
        child: child,
      ),
    );
  }
}
