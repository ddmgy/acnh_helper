import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class TimesAvailable<T extends AvailabilityTraits> extends StatelessWidget {
  final T item;

  TimesAvailable({
    Key key,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        final showTimeAsString = prefs.showTimeAsString;
        final showTimeAs12Hour = prefs.showTimeAs12Hour;

        return Center(
          child: Column(
            children: [
              if (showTimeAsString) Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  item.timesAvailable.getTimesAsString(showTimeAs12Hour: showTimeAs12Hour),
                  style: context.subtitleTextStyle(),
                ),
              ),
              Container(
                height: 56,
                width: 208,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                color: Color(0xFFEAE19A),
                child: Center(
                  child: CustomPaint(
                    foregroundPainter: _TimesPainter(
                      times: item.timesAvailable,
                    ),
                    child: Container(),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimesPainter extends CustomPainter {
  final List<bool> times;

  _TimesPainter({
    this.times,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    var sectionRect = Rect.fromLTWH(
      0,
      0,
      size.width,
      size.height / 4,
    );
    final sectionWidth = sectionRect.width / 24;
    final textStyle = TextStyle(
      color: Colors.grey[850].withOpacity(0.8),
      fontSize: 14,
      fontFamily: "Arial",
    );
    // Draw AM/PM
    drawText("AM", textStyle, sectionRect.topLeft, sectionRect, canvas);
    drawText("PM", textStyle, sectionRect.topLeft.translate(12 * sectionWidth, 0), sectionRect, canvas);
    sectionRect = sectionRect.translate(0, size.height / 4);
    // Draw 12/6 times
    drawText("12", textStyle, sectionRect.topLeft, sectionRect, canvas);
    drawText("6", textStyle, sectionRect.topLeft.translate(6 * sectionWidth, 0), sectionRect, canvas);
    drawText("12", textStyle, sectionRect.topLeft.translate(12 * sectionWidth, 0), sectionRect, canvas);
    drawText("6", textStyle, sectionRect.topLeft.translate(18 * sectionWidth, 0), sectionRect, canvas);
    sectionRect = Rect.fromLTWH(0, size.height / 2, size.width, size.height / 2);
    // Draw bar
    drawBar(canvas, sectionRect);
  }

  void drawText(String text, TextStyle textStyle, Offset offset, Rect rect, Canvas canvas) {
    var textSpan = TextSpan(
      text: text,
      style: textStyle,
    );
    var textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      offset.translate(
        -4,
        (rect.height - textPainter.height) / 2,
      ),
    );
  }

  void drawBar(Canvas canvas, Rect rect) {
    drawAvailabilityBars(canvas, rect);
    drawHourMarks(canvas, rect);
    drawDecoration(canvas, rect);
  }

  void drawAvailabilityBars(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.lime.darken()
      ..style = PaintingStyle.fill;
    final barHeight = rect.height / 2;
    final sectionWidth = rect.width / 24;
    final topLeft = rect.topLeft.translate(0, barHeight / 2);
    var barWidth = 0;
    var barStart = -1;
    for (int i = 0; i < times.length; i++) {
      if (times[i]) {
        if (barStart == -1) {
          barStart = i;
        }
        barWidth++;
      } else {
        if (barWidth > 0) {
          drawAvailabilityBar(
            topLeft,
            barStart,
            barWidth,
            barHeight,
            sectionWidth,
            canvas,
            paint,
          );
        }
        barStart = -1;
        barWidth = 0;
      }
    }
    if (barWidth > 0) {
      drawAvailabilityBar(
        topLeft,
        barStart,
        barWidth,
        barHeight,
        sectionWidth,
        canvas,
        paint,
      );
    }
  }

  void drawAvailabilityBar(Offset topLeft, int barStart, int barWidth, double barHeight, double sectionWidth, Canvas canvas, Paint paint) {
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(
          topLeft.dx + (barStart * sectionWidth),
          topLeft.dy,
          barWidth * sectionWidth,
          barHeight,
        ),
        Radius.circular(6),
      ),
      paint,
    );
  }

  void drawHourMarks(Canvas canvas, Rect rect) {
    final sectionWidth = rect.width / 24;
    final offset = rect.topLeft;
    final paint = Paint()
      ..color = Colors.grey[850].withOpacity(0.7)
      ..strokeWidth = 1;
    for (int i = 1; i < 24; i++) {
      drawHourMark(i, rect.height, canvas, offset.translate(i * sectionWidth, 0), paint);
    }
  }

  void drawHourMark(int index, double height, Canvas canvas, Offset offset, Paint paint) {
    double tickHeight;
    if (index % 6 == 0) {
      tickHeight = height;
    } else if (index % 3 == 0) {
      tickHeight = height / 2;
    } else {
      tickHeight = height / 3;
    }
    double tickOffset = height / 2 - tickHeight / 2;

    canvas.drawLine(
      offset.translate(0, height - tickHeight - tickOffset),
      offset.translate(0, height - tickOffset),
      paint,
    );
  }

  void drawDecoration(Canvas canvas, Rect rect) {
    final paint = Paint()
      ..color = Colors.grey[850].withOpacity(0.8)
      ..strokeWidth = 1.8;
    canvas.drawLine(
      rect.bottomLeft,
      rect.bottomRight,
      paint,
    );
    paint.strokeWidth = 1.2;
    canvas.drawLine(
      rect.topLeft,
      rect.bottomLeft,
      paint,
    );
    canvas.drawLine(
      rect.topRight,
      rect.bottomRight,
      paint,
    );

    paint.strokeWidth = 0.5;
    canvas.drawLine(
      rect.bottomLeft.translate(0, -3),
      rect.bottomRight.translate(0, -3),
      paint,
    );

    final topLeft = Offset(
      rect.left + (rect.width * (getCurrentTime() / 24)),
      rect.top + 4,
    );
    paint.color = Colors.redAccent;
    paint.strokeWidth = 2;
    paint.strokeCap = StrokeCap.round;
    canvas.drawLine(
      topLeft,
      topLeft.translate(0, rect.height - 3),
      paint,
    );

    paint.style = PaintingStyle.fill;
    final topArrow = Path();
    topArrow.moveTo(topLeft.dx, topLeft.dy);
    topArrow.relativeLineTo(-4, -4);
    topArrow.relativeLineTo(8, 0);
    topArrow.relativeLineTo(-4, 4);
    canvas.drawPath(topArrow, paint);

    final bottomArrow = Path();
    bottomArrow.moveTo(topLeft.dx, topLeft.dy + rect.height - 4.5);
    bottomArrow.relativeLineTo(-4, 4);
    bottomArrow.relativeLineTo(8, 0);
    bottomArrow.relativeLineTo(-4, -4);
    canvas.drawPath(bottomArrow, paint);
  }
  
  @override
  bool shouldRepaint(_TimesPainter oldDelegate) => oldDelegate.times != times;
}