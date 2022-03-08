import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marvel/ui/utils/colors.dart';

class ScreenBlock extends StatelessWidget {
  const ScreenBlock({
    required this.child,
    this.loading = false,
  });

  final Widget child;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      child: Stack(
        children: [
          child,
          Container(
            color: MarvelColors.black.withOpacity(0.5),
            child: loading
                ? Center(
                    child: SpinKitThreeBounce(
                      color: MarvelColors.black.withOpacity(0.7),
                      size: 28.0,
                    ),
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
