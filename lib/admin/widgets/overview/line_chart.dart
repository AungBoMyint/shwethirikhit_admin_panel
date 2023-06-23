/* import 'dart:math';
import 'dart:developer' as d;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../controller/admin_login_controller.dart';
import '../../controller/overview_related_controller.dart';
import '../../utils/func.dart';

final List<int> randomList = [0, 50, 100, 150, 200, 250, 300, 350, 400];

double getRandomLeftData(double v) {
  final random = Random();
  return randomList[random.nextInt(9)] + 0.0;
}

// ignore: must_be_immutable
class LineChartSample9 extends GetView<AdminLoginController> {
  LineChartSample9({super.key});

  //X And Y Data Generator
  /*  final spots = List.generate(12, (i) => i + 0.0)
      .map((x) => FlSpot(x, getRandomLeftData(x)))
      .toList(); */

  List<FlSpot> getRevenueFlSport(List<Map<String, dynamic>> json) {
    return json.map((e) {
      return FlSpot(e['month'] + 0.0, e['revenue'] + 0.0);
    }).toList();
  }

  List<FlSpot> getOrderFlSport(List<Map<String, dynamic>> json) {
    return json.map((e) {
      return FlSpot(e['month'] + 0.0, e['order'] + 0.0);
    }).toList();
  }

  String getMonth(String value) {
    switch (value) {
      case "0":
        return "Jan";
      case "1":
        return "Feb";
      case "2":
        return "Mar";
      case "3":
        return "Apr";
      case "4":
        return "May";
      case "5":
        return "Jun";
      case "6":
        return "Jul";
      case "7":
        return "Aug";
      case "8":
        return "Sep";
      case "9":
        return "Oct";
      case "10":
        return "Nov";
      case "11":
        return "Dec";
      default:
        return "error";
    }
  }

  String getMonthFromDouble(double v) {
    final value = v.round();
    switch (value) {
      case 0:
        return "Jan";
      case 1:
        return "Feb";
      case 2:
        return "Mar";
      case 3:
        return "Apr";
      case 4:
        return "May";
      case 5:
        return "Jun";
      case 6:
        return "Jul";
      case 7:
        return "Aug";
      case 8:
        return "Sep";
      case 9:
        return "Oct";
      case 10:
        return "Nov";
      case 11:
        return "Dec";
      default:
        return "error";
    }
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    if (value % 1 != 0) {
      return Container();
    }
    final style = GoogleFonts.roboto(
      color: controller.isLightTheme.value
          ? Colors.grey.shade800
          : Colors.grey.shade100,
      fontSize: min(14, 14 * chartWidth / 300),
    );
    /*  d.log("Meta Value: ${meta.formattedValue}"); */
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(getMonth(meta.formattedValue), style: style),
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta, double chartWidth) {
    final style = TextStyle(
      color: controller.isLightTheme.value
          ? Colors.grey.shade800
          : Colors.grey.shade100,
      fontSize: min(14, 14 * chartWidth / 300),
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16,
      child: Text(meta.formattedValue, style: style),
    );
  }

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final OverviewRelatedController orController = Get.find();
    return Padding(
      padding: const EdgeInsets.only(
        top: 20,
        bottom: 20,
        right: 25,
      ),
      child: LayoutBuilder(builder: (context, constrains) {
        debugPrint(
            "Line Chart Height: ${constrains.maxHeight} \n Width: ${constrains.maxWidth}");
        return Obx(() {
          final largestRevenueStream = 9;
          final yearlyData = 2;
          return SizedBox(
            height: constrains.maxHeight,
            width: constrains.maxWidth,
            child: LineChart(
              LineChartData(
                lineTouchData: LineTouchData(
                  touchTooltipData: LineTouchTooltipData(
                    maxContentWidth: 100,
                    tooltipBgColor: Colors.black,
                    getTooltipItems: (touchedSpots) {
                      return touchedSpots.map((LineBarSpot touchedSpot) {
                        final textStyle = TextStyle(
                          color: touchedSpot.bar.gradient?.colors[0] ??
                              touchedSpot.bar.color,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        );
                        return LineTooltipItem(
                          touchedSpot.barIndex == 0
                              ? '${getMonthFromDouble(touchedSpot.x)}, ${DateTime.now().year}\n'
                              : "",
                          TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.start,
                          children: [
                            TextSpan(
                              text: touchedSpot.barIndex == 0
                                  ? formatCurrency(touchedSpot.y)
                                  : "${touchedSpot.y.round()}",
                              style: TextStyle(
                                fontSize: 16,
                                color: touchedSpot.bar.color,
                                fontWeight: FontWeight.bold,
                                height: 2,
                              ),
                            )
                          ],
                        );
                      }).toList();
                    },
                  ),
                  handleBuiltInTouches: true,
                  getTouchLineStart: (data, index) => 0,
                  getTouchedSpotIndicator:
                      (LineChartBarData barData, List<int> spotIndexes) {
                    return spotIndexes.map((index) {
                      return TouchedSpotIndicatorData(
                        FlLine(
                          color: Colors.black,
                          dashArray: [5, 10],
                        ),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 8,
                            color: Colors.white,
                            strokeWidth: 2,
                            strokeColor: Colors.black,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
                lineBarsData: [
                  //revenue
                  LineChartBarData(
                    color: Colors.blue,
                    preventCurveOverShooting: true,
                    spots: getRevenueFlSport(yearlyData),
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(show: false),
                  ),
                  //Order
                  LineChartBarData(
                    preventCurveOverShooting: true,
                    color: Colors.yellow,
                    spots: getOrderFlSport(yearlyData),
                    isCurved: true,
                    isStrokeCapRound: true,
                    barWidth: 2,
                    belowBarData: BarAreaData(
                      show: false,
                    ),
                    dotData: FlDotData(show: false),
                  ),
                ],
                minX: 0,
                maxX: 11,
                minY: 0,
                maxY: (largestRevenueStream.round() +
                            (largestRevenueStream / 5).round())
                        .round() +
                    0.0,
                /* betweenBarsData: [
                    BetweenBarsData(
                      fromIndex: 0,
                      toIndex: 1,
                      color: Colors.white,
                    )
                  ], */
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          leftTitleWidgets(value, meta, constrains.maxWidth),
                      reservedSize: 56,
                    ),
                    drawBehindEverything: true,
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  //x axis
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) =>
                          bottomTitleWidgets(value, meta, constrains.maxWidth),
                      reservedSize: 36,
                      interval: 1,
                    ),
                    drawBehindEverything: true,
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  drawVerticalLine: true,
                  horizontalInterval: 1.5,
                  verticalInterval: 5,
                  checkToShowHorizontalLine: (value) {
                    return value.toInt() == 0;
                  },
                  getDrawingHorizontalLine: (_) => FlLine(
                    color: Colors.grey,
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  getDrawingVerticalLine: (_) => FlLine(
                    color: Colors.yellow.withOpacity(1),
                    dashArray: [8, 2],
                    strokeWidth: 0.8,
                  ),
                  checkToShowVerticalLine: (value) {
                    return value.toInt() == 0;
                  },
                ),
                borderData: FlBorderData(show: false),
              ),
            ),
          );
        });
      }),
    );
  }
} */