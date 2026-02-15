import 'package:expenz/utilities/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartSample extends StatefulWidget {
  final List<double>? monthlyExpenses;
  const LineChartSample({super.key, this.monthlyExpenses});

  @override
  State<LineChartSample> createState() => _LineChartSampleState();
}

class _LineChartSampleState extends State<LineChartSample> {
  late final List<Color> gradientColors = [kMainColor, kMainColor.withValues(alpha: 0.5)];

  @override
  Widget build(BuildContext context) {
    // Use provided data or default values
    final monthlyData = widget.monthlyExpenses ?? List<double>.filled(12, 0.0);

    return Stack(
      children: <Widget>[
        AspectRatio(
          aspectRatio: 1.70,
          child: Padding(
            padding: const EdgeInsets.only(
              right: 18,
              left: 12,
              top: 12,
              bottom: 12,
            ),
            child: LineChart(mainData(monthlyData)),
          ),
        ),
      ],
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: kGrey,
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('MAR', style: style);
        break;
      case 5:
        text = const Text('JUN', style: style);
        break;
      case 8:
        text = const Text('SEP', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(meta: meta, child: text);
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 10,
      color: kGrey,
    );
    String text;
    switch (value.toInt()) {
      case 1:
        text = '10K';
        break;
      case 3:
        text = '30k';
        break;
      case 5:
        text = '50k';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData(List<double> monthlyExpenses) {
    // Convert monthly expenses to FlSpot data
    List<FlSpot> spots = [];
    for (int i = 0; i < monthlyExpenses.length; i++) {
      // Scale the data to fit the chart (dividing by 10000 for better visualization)
      final scaledValue = monthlyExpenses[i] / 10000;
      spots.add(FlSpot(i.toDouble(), scaledValue.clamp(0, 6)));
    }

    // If no data, use default spots
    if (spots.isEmpty ||
        spots.every((spot) => spot.y == 0)) {
      spots = const [
        FlSpot(0, 3),
        FlSpot(2.6, 2),
        FlSpot(4.9, 5),
        FlSpot(6.8, 3.1),
        FlSpot(8, 4),
        FlSpot(9.5, 3),
        FlSpot(11, 4),
      ];
    }

    return LineChartData(
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 30,
          ),
        ),
      ),
      borderData: FlBorderData(show: false),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          gradient: LinearGradient(colors: gradientColors),
          barWidth: 5,
          isStrokeCapRound: false,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            gradient: LinearGradient(
              colors: [kMainColor.withValues(alpha: 0.9), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            show: true,
          ),
        ),
      ],
    );
  }
}
