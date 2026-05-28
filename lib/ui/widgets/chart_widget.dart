import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:seimbangin_app/models/donut_chart_model.dart';
import 'package:seimbangin_app/shared/theme/theme.dart';

class AnalyticsBarChart extends StatelessWidget {
  final double currentIncome;
  final double currentOutcome;

  const AnalyticsBarChart({
    super.key,
    required this.currentIncome,
    required this.currentOutcome,
  });

  @override
  Widget build(BuildContext context) {
    double maxY =
        currentIncome > currentOutcome ? currentIncome : currentOutcome;
    if (maxY == 0) maxY = 1000;
    maxY = maxY * 1.25; // Add some headroom

    return SizedBox(
      height: 250,
      child: BarChart(
        BarChartData(
          maxY: maxY,
          gridData: FlGridData(
            show: true,
            drawHorizontalLine: true,
            drawVerticalLine: false,
            horizontalInterval: maxY / 4,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Colors.grey.withValues(alpha: 0.3),
                strokeWidth: 1,
                dashArray: [5, 5],
              );
            },
          ),
          titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  switch (value.toInt()) {
                    case 0:
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Pemasukan',
                            style: context.text.blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      );
                    case 1:
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text('Pengeluaran',
                            style: context.text.blackTextStyle.copyWith(
                                fontSize: 12, fontWeight: FontWeight.w600)),
                      );
                    default:
                      return const Text('');
                  }
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 45,
                getTitlesWidget: (value, meta) {
                  if (value == maxY || value == 0) {
                    return const SizedBox.shrink();
                  }
                  String text;
                  if (value >= 1000000) {
                    text = '${(value / 1000000).toStringAsFixed(1)}jt';
                  } else if (value >= 1000) {
                    text = '${(value / 1000).toStringAsFixed(0)}k';
                  } else {
                    text = value.toStringAsFixed(0);
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: Text(
                      text,
                      textAlign: TextAlign.right,
                      style: context.text.greyTextStyle.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          barGroups: [
            BarChartGroupData(
              x: 0,
              barRods: [
                BarChartRodData(
                  toY: currentIncome,
                  color: context.color.textGreenColor,
                  width: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1,
              barRods: [
                BarChartRodData(
                  toY: currentOutcome,
                  color: context.color.textWarningColor,
                  width: 30,
                  borderRadius: BorderRadius.circular(6),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AnalyticsDonutChart extends StatefulWidget {
  final List<ChartSection> sections;
  const AnalyticsDonutChart({super.key, required this.sections});

  @override
  State<AnalyticsDonutChart> createState() => _AnalyticsDonutChartState();
}

class _AnalyticsDonutChartState extends State<AnalyticsDonutChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chartSize = constraints.maxWidth * 0.8; // 80% dari parent width

        return Center(
          child: SizedBox(
            width: chartSize,
            height: chartSize,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (event, response) {
                    setState(() {
                      touchedIndex =
                          response?.touchedSection?.touchedSectionIndex ?? -1;
                    });
                  },
                ),
                sectionsSpace: 0,
                centerSpaceRadius: chartSize * 0.2,
                sections: _buildSections(chartSize),
              ),
            ),
          ),
        );
      },
    );
  }

  List<PieChartSectionData> _buildSections(double chartSize) {
    final double totalValue =
        widget.sections.fold(0.0, (sum, item) => sum + item.value);

    return List.generate(widget.sections.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? chartSize * 0.05 : chartSize * 0.03;
      final radius = isTouched ? chartSize * 0.35 : chartSize * 0.3;
      final double percentage = (widget.sections[i].value / totalValue) * 100;

      return PieChartSectionData(
        color: widget.sections[i].color,
        value: widget.sections[i].value,
        radius: radius,
        title: percentage > 5 ? '${percentage.toStringAsFixed(0)}%' : '',
        showTitle: true,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }
}
