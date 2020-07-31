import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:acnh_helper/hemisphere.dart';
import 'package:acnh_helper/month.dart';
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
    return Consumer<PreferencesProvider>(
      builder: (context, prefs, _) {
        final calendarOptions = prefs.calendarOptions;
        final months = hemisphere == Hemisphere.Northern ? item.monthsAvailableNorthern : item.monthsAvailableSouthern;
        final showMonthsAsString = prefs.showMonthsAsString;

        return Center(
          child: Column(
            children: [
              if (showMonthsAsString) Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  months.getMonthsAsString(),
                  style: context.subtitleTextStyle(),
                ),
              ),
              Container(
                height: 80,
                width: 200,
                padding: const EdgeInsets.all(4),
                color: Color(0xFFEAE19A),
                child: Center(
                  child: CustomPaint(
                    foregroundPainter: _MonthsPainter(
                      months: months,
                      month: calendarOptions.month == Month.Current ? Month.values[getCurrentMonth()] : calendarOptions.month,
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

class _MonthsPainter extends CustomPainter {
  final List<bool> months;
  final Month month;

  _MonthsPainter({
    this.months,
    this.month,
  });

  @override
  void paint(Canvas canvas, Size size) {
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
    if (index == month.index - 1) {
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
      text: Month.values[index + 1].getShortName(),
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