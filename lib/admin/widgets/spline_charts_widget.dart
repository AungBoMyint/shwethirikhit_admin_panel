import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SplineChartsWidget extends StatelessWidget {
  const SplineChartsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<ChartData> chartData = [
      ChartData('Jan', 21),
      ChartData('Feb', 0),
      ChartData('Mar', 25),
      ChartData('Apr', 100),
      ChartData('May', 150),
      ChartData('Jun', 30),
      ChartData('Jul', 500),
      ChartData('Aug', 350),
      ChartData('Sep', 230),
      ChartData('Oct', 120),
      ChartData('Nov', 400),
      ChartData('Dec', 240)
    ];
    return Container(
        child: SfCartesianChart(
            primaryXAxis: CategoryAxis(),
            series: <ChartSeries>[
          SplineSeries<ChartData, String>(
            dataSource: chartData,
            xValueMapper: (ChartData data, _) => data.x,
            yValueMapper: (ChartData data, _) => data.y,
            markerSettings: MarkerSettings(
              isVisible: true,
            ),
          ),
        ]));
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final double? y;
}
