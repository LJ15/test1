import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../../constant/telliot_colors.dart';

class TelliotProgressIndicator extends StatefulWidget {
  final double width;
  final double height;
  final double stroke;
  final Color color;
  final List<Color> colorList;
  final String label;
  final TextStyle labelStyle;

  TelliotProgressIndicator({
    this.width = 40,
    this.height = 40,
    this.color = TelliotColors.primary,
    this.colorList,
    this.stroke = 4,
    this.label,
    this.labelStyle = const TextStyle(
      fontSize: 12,
      height: 14 / 12,
      color: TelliotColors.gray1,
    ),
  });

  @override
  State<TelliotProgressIndicator> createState() =>
      _TelliotProgressIndicatorState();
}

class _TelliotProgressIndicatorState extends State<TelliotProgressIndicator>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController =
    AnimationController(vsync: this, duration: Duration(seconds: 1))
      ..addListener(() {
        setState(() {});
      });

    _animationController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      decoration: BoxDecoration(
        color: TelliotColors.white,
        backgroundBlendMode: BlendMode.colorBurn,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.label != null)
            Text(widget.label, style: widget.labelStyle),
          RotationTransition(
            turns:
            Tween<double>(begin: 0, end: 1).animate(_animationController),
            child: GradientProgressIndicator(
                strokewidth: widget.stroke,
                gradientColors: [TelliotColors.primary, TelliotColors.blue],
                radius: widget.width),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class GradientProgressIndicator extends StatelessWidget {
  final double radius;
  final List<Color> gradientColors;
  final double strokewidth;

  GradientProgressIndicator(
      {this.gradientColors, this.radius, this.strokewidth});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size.fromRadius(radius),
      painter: GradientProgressIndicatorPainter(
          radius: radius,
          gradientColors: gradientColors,
          strokeWidth: strokewidth),
    );
  }
}

class GradientProgressIndicatorPainter extends CustomPainter {
  final double radius;
  final List<Color> gradientColors;
  final double strokeWidth;
  GradientProgressIndicatorPainter(
      {this.radius, this.gradientColors, this.strokeWidth});

  @override
  void paint(Canvas canvas, Size size) {
    size = Size.fromRadius(radius);
    final offset = strokeWidth / 2;
    final rect = Offset(offset, offset) &
    Size(size.width - strokeWidth, size.height - strokeWidth);
    Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..blendMode = BlendMode.hardLight;
    paint.shader =
        SweepGradient(colors: gradientColors, startAngle: 0.0, endAngle: 2 * pi)
            .createShader(rect);
    canvas.drawArc(rect, 0, 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
