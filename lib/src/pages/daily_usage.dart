// ignore_for_file: import_of_legacy_library_into_null_safe

import 'package:flutter/material.dart';
import 'package:tutor_me/src/colorpallete.dart';
import 'package:fl_chart/fl_chart.dart';

// ignore: must_be_immutable

class DailyUsage extends StatelessWidget {
  DailyUsage({Key? key}) : super(key: key);

  final List<Color> colorList = [
    colorBlueTeal,
    colorLightBlueTeal,
  ];
  @override
  Widget build(BuildContext context) {
    return LineChart(

      LineChartData(
        minX: 1,
        maxX: 7,
        minY: 0,
        maxY: 6,
        titlesData: LineTitles.getTitleData(),
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: colorOrange,
              strokeWidth: 1,
            );
          },
          drawVerticalLine: false,
        ),
        borderData: FlBorderData(
            show: true, border: Border.all(color: colorOrange, width: 1)),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(1, 2),
              const FlSpot(2, 2),
              const FlSpot(3, 3),
              const FlSpot(4, 5),
              const FlSpot(5, 3),
              const FlSpot(6, 2),
              const FlSpot(7, 2),
            ],
            isCurved: true,
            barWidth: 5,
            gradient: const LinearGradient(
              colors: [
                colorBlueTeal,
                colorLightBlueTeal,
              ],
            ),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  colorBlueTeal.withOpacity(0.5),
                  colorOrange.withOpacity(0.2),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LineTitles {
  static getTitleData() {
    return FlTitlesData(

        show: true,
        leftTitles: AxisTitles(
          
          sideTitles: SideTitles(
            showTitles: false,
          )
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false
          )
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          )
        ),
        bottomTitles: AxisTitles(

          sideTitles: SideTitles(
            showTitles: true,
          
            reservedSize: 25,
            getTitlesWidget: (value, context) {
              switch (value.toInt()) {
                case 1:
                  return const Text(
                    'Sun',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                case 2:
                  return const Text(
                    'Mon',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                case 3:
                  return const Text(
                    'Tue',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                case 4:
                  return const Text(
                    'Wed',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                case 5:
                  return const Text(
                    'Thurs',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                case 6:
                  return const Text(
                    'Fri',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
                default:
                  return const Text(
                    'Sat',
                    style: TextStyle(
                      color: colorOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  );
              }
            },
          ),
        ));
        
  }
}
