import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:clock_neum/utils/app_themes.dart';
import 'package:flutter/material.dart';

class CustomClock extends StatefulWidget {
  CustomClock({Key key}) : super(key: key);

  @override
  _CustomClockState createState() => _CustomClockState();
}

class _CustomClockState extends State<CustomClock> {
  Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      setState(() {});
    });
    super.initState();
  }

  @override
  void setState(fn) {
    if (this.mounted) {
      super.setState(fn);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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

    var centerDotBrush = Paint()..color = Colors.white;
    var centerSecDotBrush = Paint()..color = AppColors.colorAccent;
    var centerSecUpDotBrush = Paint()..color = Colors.white;

    var centerMinDotBrush = Paint()..color = AppColors.colorAccent;
    var centerHourDotBrush = Paint()..color = AppColors.colorAccentDark;

    var secHandBrush = Paint()
      ..color = AppColors.colorAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..strokeCap = StrokeCap.round;

    var minHandBrush = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..strokeCap = StrokeCap.round;

    var hourHandBrush = Paint()
      ..color = AppColors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7.0
      ..strokeCap = StrokeCap.round;

    // canvas.drawCircle(center, 12, centerDotBrush);

    var hourHandX = centerX + 50 * cos((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    var hourHandY = centerY + 50 * sin((dateTime.hour * 30 + dateTime.minute * 0.5) * pi / 180);
    canvas.drawLine(center, Offset(hourHandX, hourHandY), hourHandBrush);

    // canvas.drawCircle(center, 8, centerDotBrush);

    var minHandX = centerX + 60 * cos((dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180);
    var minHandY = centerY + 60 * sin((dateTime.minute * 6 + dateTime.second * 0.1) * pi / 180);
    canvas.drawLine(center, Offset(minHandX, minHandY), minHandBrush);

    canvas.drawCircle(center, 10, centerDotBrush);

    var secHandX = centerX + 75 * cos(dateTime.second * 6 * pi / 180);
    var secHandY = centerY + 75 * sin(dateTime.second * 6 * pi / 180);
    canvas.drawLine(center, Offset(secHandX, secHandY), secHandBrush);

    canvas.drawCircle(center, 6, centerSecDotBrush);
    canvas.drawCircle(center, 2, centerSecUpDotBrush);

    canvas.drawShadow(Path(), Colors.black, 12.0, true);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
