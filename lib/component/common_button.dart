import 'package:flutter/material.dart';
import '../constant/telliot_colors.dart';

class CommonButton extends StatelessWidget {
  final String label;
  final Border border;
  final Color activeColor;
  final Color inactiveColor;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final TextStyle labelStyle;
  final double width;
  final void Function() onPress;
  final double radius;
  final List<BoxShadow> shadow;
  final bool full;
  final MainAxisAlignment alignment;

  CommonButton({
    this.label = '',
    this.border = const Border(),
    this.labelStyle = const TextStyle(
      fontSize: 18,
      height: 19.83 / 18,
      color: TelliotColors.white,
    ),
    this.activeColor = TelliotColors.primary,
    this.inactiveColor = TelliotColors.gray3,
    this.padding,
    this.margin,
    this.width,
    this.onPress,
    this.radius = 0,
    this.shadow = const [],
    this.full = false,
    this.alignment = MainAxisAlignment.center,
  });

  Widget _button(BuildContext context) {
    return GestureDetector(
      onTap: onPress != null
          ? Feedback.wrapForTap(() {
        onPress();
      }, context)
          : null,
      child: Container(
        alignment: Alignment.center,
        padding: padding,
        margin: margin,
        width: width,
        decoration: BoxDecoration(
          border: border,
          borderRadius: BorderRadius.circular(radius),
          color: onPress != null ? activeColor : inactiveColor,
          boxShadow: shadow,
        ),
        child: Text(label,
            style: onPress != null
                ? labelStyle
                : labelStyle.apply(color: TelliotColors.gray1)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (full) return _button(context);
    return Row(
      mainAxisAlignment: alignment,
      children: [_button(context)],
    );
  }
}
