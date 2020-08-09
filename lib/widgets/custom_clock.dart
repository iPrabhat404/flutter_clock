import 'dart:async';
import 'dart:math';

import 'package:clock_neum/utils/app_themes.dart';
import 'package:flutter/material.dart';

class CustomClock extends StatefulWidget {
  CustomClock({Key key}) : super(key: key);

  @override
  _CustomClockState createState() => _CustomClockState();
}

class _CustomClockState extends State<CustomClock> {
  @override
  void initState() {
    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Transform.rotate(
        angle: -pi / 2,
        child: SizedBox(
          width: 300,
          height: 300,
          child: CustomPaint(
            painter: CustomClockPainter(),
          ),
        ),
      ),
    );
  }
}

class CustomClockPainter extends CustomPainter {
  var dateTime = DateTime.now();

  /// 60 seconds = 360 degrees for second hand => 360 / 60 = 6 degrees per second
  /// 60 minutes = 360 degrees for minute hand => 360 / 60 / 60 = 0.1 degrees per second
  /// 12 hours = 360 degree for hour hand => 360 / 12 / 60  = 0.5 degrees per minute

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

    var centerDotBrush = Paint()..color = Colors.white;

    var secHandBrush = Paint()
      ..color = AppColors.colorAccentLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;

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

    var minHandBrush = Paint()
      ..color = AppColors.colorAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6.0
      ..strokeCap = StrokeCap.round;

    var hourHandBrush = Paint()
      ..color = AppColors.colorAccentDark
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8.0
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 40, fillBrush);
    canvas.drawCircle(center, radius - 40, outLineBrush);

    var outerCircleRadius = radius - 56;
    var innerCircleRadius = radius - 70;

    for (int i = 0; i < 360; i += 6) {

      var x1 = centerX + outerCircleRadius * cos(i * pi / 180);
      var y1 = centerY + outerCircleRadius * sin(i * pi / 180);

      var x2 = centerX + (i % 30 == 0 ? innerCircleRadius : innerCircleRadius + 8) * cos(i * pi / 180);
      var y2 = centerX + (i % 30 == 0 ? innerCircleRadius : innerCircleRadius + 8)  * sin(i * pi / 180);

      i % 30 == 0
          ? canvas.drawLine(Offset(x1, y1), Offset(x2, y2), hourDashBrush)
          : canvas.drawLine(Offset(x1, y1), Offset(x2, y2), minuteDashBrush);
    }
    var hourHandX = centerX + 60 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY + 60 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    var minHandX = centerX + 70 * cos((dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180);
    var minHandY = centerY + 70 * sin((dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    var secHandX = centerX + 80 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + 80 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 16, centerDotBrush);
    canvas.drawShadow(Path(), Colors.black, 12.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
