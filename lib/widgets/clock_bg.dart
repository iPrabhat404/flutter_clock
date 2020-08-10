import 'dart:math';

import 'package:clock_neum/utils/app_themes.dart';
import 'package:flutter/material.dart';

class CustomClockBg extends StatelessWidget {
  const CustomClockBg({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SizedBox(
        width: 300,
        height: 300,
        child: CustomPaint(
          painter: CustomClockBgPainter(),
        ),
      ),
    );
  }
}

class CustomClockBgPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var centerX = size.width / 2;
    var centerY = size.height / 2;
    var center = Offset(centerX, centerY);
    var radius = min(centerX, centerY);

    var fillBrush = Paint()..color = AppColors.colorPrimary;

    var outLineBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 16.0;

    var hourDashBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

    var minuteDashBrush = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outLineBrush);

    var outerCircleRadius = radius - 56;
    var innerCircleRadius = radius - 70;

    for (int i = 0; i < 360; i += 6) {
      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 =
          centerX + (i % 30 == 0 ? innerCircleRadius : innerCircleRadius + 8) * cos(i * pi / 180);
      var y2 =
          centerX + (i % 30 == 0 ? innerCircleRadius : innerCircleRadius + 8) * sin(i * pi / 180);

      i % 30 == 0
          ? canvas.drawLine(Offset(x1, y1), Offset(x2, y2), hourDashBrush)
          : canvas.drawLine(Offset(x1, y1), Offset(x2, y2), minuteDashBrush);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
