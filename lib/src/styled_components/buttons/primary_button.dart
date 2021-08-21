import 'package:canton_design_system/canton_design_system.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CantonPrimaryButton extends StatelessWidget {
  final String? buttonText;
  final MainAxisAlignment? alignment;
  final EdgeInsets? containerPadding;
  final bool enabled;
  final void Function()? onPressed;
  final double? iconSize, iconPadding, containerWidth, containerHeight;
  final BorderSide? border;
  final BorderRadius? radius;
  final Widget? prefixIcon, suffixIcon;
  final Color? containerColor, textColor, iconColor;

  const CantonPrimaryButton({
    this.buttonText,
    this.onPressed,
    this.alignment,
    this.border,
    this.containerPadding,
    this.radius,
    this.enabled = true,
    this.iconSize,
    this.iconPadding,
    this.containerWidth,
    this.containerHeight,
    this.prefixIcon,
    this.suffixIcon,
    this.containerColor,
    this.textColor,
    this.iconColor,
  });

  @override
  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    Widget prefixIconWidget() {
      if (prefixIcon == null) return Container();

      return Container(child: prefixIcon);
    }

    Widget suffixIconWidget() {
      if (suffixIcon == null) return Container();

      return Container(
        padding: const EdgeInsets.only(left: 16.0),
        child: suffixIcon,
      );
    }

    Widget textWidget() {
      if (buttonText == null) return Container();

      return Text(
        buttonText!,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: enabled
                  ? textColor
                  : Theme.of(context).colorScheme.secondaryVariant,
            ),
      );
    }

    return Container(
      decoration: ShapeDecoration(
        color: enabled
            ? containerColor ?? Theme.of(context).primaryColor
            : Theme.of(context).colorScheme.secondary,
        shape: SquircleBorder(
          radius: radius ?? BorderRadius.circular(37),
          side: border ?? BorderSide.none,
        ),
      ),
      height: containerHeight ?? 55.0,
      width: containerWidth ?? size.width,
      child: CantonPrimaryButton2(
        padding:
            containerPadding ?? const EdgeInsets.symmetric(horizontal: 16.0),
        color: containerColor ?? Theme.of(context).primaryColor,
        disabledColor: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.zero,
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: alignment ?? MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            prefixIconWidget(),
            textWidget(),
            suffixIconWidget(),
          ],
        ),
      ),
    );
  }
}

const EdgeInsets _kButtonPadding = EdgeInsets.all(16.0);
const EdgeInsets _kBackgroundButtonPadding = EdgeInsets.symmetric(
  vertical: 14.0,
  horizontal: 64.0,
);

class CantonPrimaryButton2 extends StatefulWidget {
  const CantonPrimaryButton2({
    Key? key,
    required this.child,
    this.prefixIcon,
    this.suffixIcon,
    this.buttonText,
    this.iconColor,
    this.textColor,
    this.padding,
    this.border,
    this.color,
    this.iconSize,
    this.iconPadding,
    this.containerHeight,
    this.containerWidth,
    this.disabledColor = CupertinoColors.quaternarySystemFill,
    this.minSize = kMinInteractiveDimensionCupertino,
    this.pressedOpacity = 0.4,
    this.borderRadius = const BorderRadius.all(Radius.circular(8.0)),
    this.alignment = MainAxisAlignment.spaceBetween,
    required this.onPressed,
  })  : assert(pressedOpacity == null ||
            (pressedOpacity >= 0.0 && pressedOpacity <= 1.0)),
        super(key: key);

  final Widget child;
  final Widget? prefixIcon, suffixIcon;
  final String? buttonText;
  final BorderSide? border;
  final EdgeInsetsGeometry? padding;
  final Color? color, textColor, iconColor;
  final Color disabledColor;
  final double? iconSize, iconPadding, containerWidth, containerHeight;
  final VoidCallback? onPressed;
  final double? minSize;
  final double? pressedOpacity;
  final BorderRadius? borderRadius;
  final MainAxisAlignment alignment;
  bool get enabled => onPressed != null;

  @override
  _CantonPrimaryButton2State createState() => _CantonPrimaryButton2State();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
        .add(FlagProperty('enabled', value: enabled, ifFalse: 'disabled'));
  }
}

class _CantonPrimaryButton2State extends State<CantonPrimaryButton2>
    with SingleTickerProviderStateMixin {
  static const Duration kFadeOutDuration = Duration(milliseconds: 10);
  static const Duration kFadeInDuration = Duration(milliseconds: 100);
  final Tween<double> _opacityTween = Tween<double>(begin: 1.0);

  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      value: 0.0,
      vsync: this,
    );
    _opacityAnimation = _animationController
        .drive(CurveTween(curve: Curves.decelerate))
        .drive(_opacityTween);
    _setTween();
  }

  @override
  void didUpdateWidget(CantonPrimaryButton2 old) {
    super.didUpdateWidget(old);
    _setTween();
  }

  void _setTween() {
    _opacityTween.end = widget.pressedOpacity ?? 1.0;
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      _buttonHeldDown = true;
      _animate();
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      _buttonHeldDown = false;
      _animate();
    }
  }

  void _animate() {
    if (_animationController.isAnimating) return;
    final bool wasHeldDown = _buttonHeldDown;
    final TickerFuture ticker = _buttonHeldDown
        ? _animationController.animateTo(1.0, duration: kFadeOutDuration)
        : _animationController.animateTo(0.0, duration: kFadeInDuration);
    ticker.then<void>((void value) {
      if (mounted && wasHeldDown != _buttonHeldDown) _animate();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    final bool enabled = widget.enabled;

    Widget prefixIconWidget() {
      if (widget.prefixIcon == null) return Container();

      return Container(child: widget.prefixIcon);
    }

    Widget suffixIconWidget() {
      if (widget.suffixIcon == null) return Container();

      return Container(
        padding: const EdgeInsets.only(left: 16.0),
        child: widget.suffixIcon,
      );
    }

    Widget textWidget() {
      if (widget.buttonText == null) return Container();

      return Text(
        widget.buttonText!,
        style: Theme.of(context).textTheme.button?.copyWith(
              color: enabled
                  ? widget.textColor
                  : Theme.of(context).colorScheme.secondaryVariant,
            ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: ConstrainedBox(
          constraints: widget.minSize == null
              ? const BoxConstraints()
              : BoxConstraints(
                  minWidth: widget.minSize!,
                  minHeight: widget.minSize!,
                ),
          child: FadeTransition(
            opacity: _opacityAnimation,
            child: DecoratedBox(
              decoration: ShapeDecoration(
                shape: SquircleBorder(
                    radius: widget.borderRadius, side: widget.border!),
                color: widget.color != null && !enabled
                    ? CupertinoDynamicColor.resolve(
                        widget.disabledColor, context)
                    : widget.color,
              ),
              child: Container(
                height: widget.containerHeight ?? 55.0,
                width: widget.containerWidth ?? size.width,
                padding: widget.padding ??
                    (widget.color != null
                        ? _kBackgroundButtonPadding
                        : _kButtonPadding),
                child: Row(
                  mainAxisAlignment: widget.alignment,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    prefixIconWidget(),
                    textWidget(),
                    suffixIconWidget(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
