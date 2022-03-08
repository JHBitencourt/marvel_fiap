import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:marvel/ui/utils/colors.dart';

const buttonMaxWidth = 400.0;
const buttonHeight = 48.0;
const borderRadius = 3.0;

class GoogleSignIn extends StatelessWidget {
  const GoogleSignIn({
    Key? key,
    this.text = 'Continuar com a Google',
    required this.onTap,
  }) : super(key: key);

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    EdgeInsets padding;
    Widget asset;
    Color textColor;
    Color backgroundColor;
    padding = const EdgeInsets.only(right: 10, top: 12, bottom: 12, left: 1);
    asset = Image.asset(
      'assets/graphics/images/google_light.png',
      width: 46,
    );
    textColor = MarvelColors.black;
    backgroundColor = MarvelColors.white;

    final child = Container(
      constraints: const BoxConstraints(
        maxHeight: buttonHeight,
        maxWidth: buttonMaxWidth,
      ),
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          asset,
          Expanded(
            child: Center(
              child: Text(
                text,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyText1?.copyWith(
                      color: textColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ),
        ],
      ),
    );

    return ElevatedButton(
      child: child,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: backgroundColor,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      onPressed: onTap,
    );
  }
}

class ElevatedButtonMarvel extends StatefulWidget {
  const ElevatedButtonMarvel._({
    required this.brightness,
    this.text,
    this.controller,
    this.child,
    this.onTap,
    this.backgroundColor = MarvelColors.primary,
    this.textColor = MarvelColors.white,
    this.disableSqueezeAnimation = false,
  });

  factory ElevatedButtonMarvel.normal({
    String? text,
    ButtonLabAnimationController? controller,
    Brightness brightness = Brightness.dark,
    Widget? child,
    Color? backgroundColor,
    Color? textColor,
    VoidCallback? onTap,
    bool? disableSqueezeAnimation,
  }) {
    backgroundColor ??= brightness == Brightness.dark
        ? MarvelColors.white
        : MarvelColors.primary;
    textColor ??= brightness == Brightness.dark
        ? MarvelColors.primary
        : MarvelColors.white;

    return ElevatedButtonMarvel._(
      controller: controller,
      brightness: brightness,
      child: child,
      text: text,
      onTap: onTap,
      backgroundColor: backgroundColor,
      textColor: textColor,
      disableSqueezeAnimation: disableSqueezeAnimation ?? false,
    );
  }

  /// If provided, the Button will be enabled to animate itself.
  /// Can be used to control the Button animation if desired.
  final ButtonLabAnimationController? controller;
  final Brightness brightness;
  final Widget? child;
  final String? text;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color textColor;

  /// If the button has a controller and the default squeeze animation is
  /// not desired
  final bool disableSqueezeAnimation;

  bool get hasAnimation => controller != null;

  bool get isDisabled => onTap == null;

  @override
  _ElevatedButtonMarvelState createState() => _ElevatedButtonMarvelState();
}

class _ElevatedButtonMarvelState extends State<ElevatedButtonMarvel>
    with TickerProviderStateMixin {
  AnimationController? _squeezeController;
  AnimationController? _borderController;
  Animation? _squeezeAnimation;

  bool _loading = false;
  final int animationMilliseconds = 500;

  @override
  void initState() {
    super.initState();

    if (widget.hasAnimation) {
      _buildAnimationControllers();
      _buildSqueezeAnimation();

      widget.controller?._addListeners(
        resetListener: _resetListener,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final buttonChild = _buttonChild();
    if (widget.hasAnimation) {
      return AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _loading
            ? OutlinedButton(
                child: buttonChild,
                style: ElevatedButton.styleFrom(
                  side: const BorderSide(
                    color: MarvelColors.primary,
                    width: 1,
                  ),
                  padding: EdgeInsets.zero,
                  primary: MarvelColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                onPressed: () {},
              )
            : ElevatedButton(
                child: buttonChild,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  onSurface: MarvelColors.primary,
                  shadowColor:
                      widget.isDisabled ? MarvelColors.transparent : null,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                onPressed: widget.isDisabled
                    ? null
                    : () {
                        if (widget.hasAnimation) {
                          _startAnimation();
                        } else {
                          widget.onTap!();
                        }
                      },
              ),
      );
    }

    return ElevatedButton(
      child: buttonChild,
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.zero,
        primary: widget.backgroundColor,
        onSurface: MarvelColors.primary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
        ),
      ),
      onPressed: widget.onTap,
    );
  }

  void _startAnimation() {
    _loading = true;
    _squeezeController?.forward();
    _borderController?.forward();
  }

  Widget _buttonChild() {
    Widget buttonChild = widget.child ??
        Text(
          '${widget.text}',
          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                color: widget.textColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
        );
    if (widget.hasAnimation) {
      buttonChild = AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: _loading
            ? const SpinKitThreeBounce(color: MarvelColors.primary, size: 18)
            : buttonChild,
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: buttonHeight,
        maxWidth: widget.hasAnimation && !widget.disableSqueezeAnimation
            ? _squeezeAnimation?.value
            : buttonMaxWidth,
      ),
      child: Center(child: buttonChild),
    );
  }

  @override
  void dispose() {
    _squeezeController?.dispose();
    _borderController?.dispose();
    super.dispose();
  }

  void _resetListener() {
    _squeezeController?.reverse();
    _borderController?.reverse();
    Future.delayed(Duration(
      milliseconds: (animationMilliseconds * 0.7).round(),
    )).then((_) {
      setState(() {
        _loading = false;
      });
    });
  }

  void _buildAnimationControllers() {
    _squeezeController = AnimationController(
      duration: Duration(milliseconds: animationMilliseconds),
      vsync: this,
    );
    _borderController = AnimationController(
      duration: Duration(milliseconds: (animationMilliseconds / 2).round()),
      vsync: this,
    );
  }

  void _buildSqueezeAnimation() {
    _squeezeAnimation = Tween<double>(begin: buttonMaxWidth, end: 60.0).animate(
      CurvedAnimation(
        parent: _squeezeController!,
        curve: Curves.easeInOutCirc,
      ),
    );
    _squeezeAnimation?.addListener(() {
      setState(() {});
    });
    _squeezeAnimation?.addStatusListener((state) {
      if (state == AnimationStatus.completed) {
        if (widget.onTap != null) widget.onTap!();
      }
    });
  }
}

class ButtonLabAnimationController {
  ButtonLabAnimationController();

  VoidCallback? _resetListener;

  void _addListeners({
    VoidCallback? resetListener,
  }) {
    _resetListener = resetListener;
  }

  /// Must be called to stop the progress animation.
  /// The Button will reset to its original size.
  void reset() {
    if (_resetListener != null) _resetListener!();
  }
}
