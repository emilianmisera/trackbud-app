import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';




// Data structure for chart sections
class ChartSectionData {
  final PieChartSectionData sectionData;
  final Image icon;

  ChartSectionData({required this.sectionData, required this.icon});
}