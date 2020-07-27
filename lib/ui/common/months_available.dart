import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/calendar_options.dart';
import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/model/traits.dart';
import 'package:acnh_helper/provider/preferences_provider.dart';
import 'package:acnh_helper/utils.dart';

class MonthsAvailable<T extends AvailabilityTraits> extends StatelessWidget {
  final T item;
  final Hemisphere hemisphere;

  MonthsAvailable({
    Key key,
    @required this.item,
    @required this.hemisphere,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<PreferencesProvider, CalendarOptions>(
      selector: (context, provider) => provider.calendarOptions,
      builder: (context, calendarOptions, _) {
        return Center(
          child: Container(
            height: 80,
            width: 200,
            padding: const EdgeInsets.all(4),
            color: Color(0xFFEAE19A),
            child: Center(
              child: CustomPaint(
                foregroundPainter: _MonthsPainter(
                  months: hemisphere == Hemisphere.Northern ? item.monthsAvailableNorthern : item.monthsAvailableSouthern,
                  month: calendarOptions.month == 0 ? getCurrentMonth() : calendarOptions.month,
                ),
                child: Container(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _MonthsPainter extends CustomPainter {
  final List<bool> months;
  final int month;

  _MonthsPainter({
    this.months,
    this.month,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw each individual box with month, indicator of whether item is available that month, and indicator if it is current month
    // Draw overlay if item is not currently available?
    final cellWidth = size.width / 4;
    final cellHeight = size.height / 3;
    for (int index = 0; index < months.length; index++) {
      drawCalendarBox(index, cellWidth, cellHeight, canvas);
    }
  }

  void drawCalendarBox(int index, double cellWidth, double cellHeight, Canvas canvas) {
    int x = index % 4;
    int y = index ~/ 4;
    var paint = Paint();

    // Frame
    if (index == month - 1) {
      if (months[index]) {
        paint.color = Colors.redAccent;
      } else {
        paint.color = Colors.redAccent.withOpacity(0.5);
      }
      paint.strokeWidth = 2;
    } else {
      paint.color = Colors.grey[850].withOpacity(0.7);
    }
    paint.style = PaintingStyle.stroke;
    final rect = Rect.fromLTWH(
      x * cellWidth,
      y * cellHeight,
      cellWidth,
      cellHeight,
    );
    canvas.drawRect(rect, paint);

    // Available for month
    if (months[index]) {
      final boxRect = RRect.fromRectAndRadius(
        rect.deflate(2.5),
        Radius.circular(2),
      );
      paint.color = Colors.lime.darken();
      paint.style = PaintingStyle.fill;
      canvas.drawRRect(boxRect, paint);
    }

    // Text
    if (months[index]) {
      paint.color = Colors.grey[850].withOpacity(0.7);
    } else {
      paint.color = Colors.grey[850].withOpacity(0.15);
    }

    final textStyle = TextStyle(
      color: paint.color,
      fontSize: 16,
      fontFamily: "Arial",
      fontStyle: FontStyle.italic,
    );
    final textSpan = TextSpan(
      text: getMonthName(index + 1),
      style: textStyle,
    );
    final textPainter = TextPainter(
      text: textSpan,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(
      minWidth: 0,
      maxWidth: rect.width,
    );
    textPainter.paint(
      canvas,
      Offset(
        rect.left + (rect.width - textPainter.width) / 2,
        rect.top + (rect.height - textPainter.height) / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_MonthsPainter oldDelegate) {
    return oldDelegate.months != months && oldDelegate.month != month;
  }
}