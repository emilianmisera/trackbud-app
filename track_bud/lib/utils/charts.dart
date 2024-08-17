import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

class ChartTile extends StatelessWidget {
  final Widget chartChild;
  const ChartTile({super.key, required this.chartChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(top: CustomPadding.bigSpace, bottom: CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(Constants.buttonBorderRadius),
      ),
      child: chartChild,
    );
  }
}

// Donut Chart in Analysis Screen
class DonutChart extends StatefulWidget {
  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  // List of pie chart sections with their properties
  /*
  value Paramter info:
  depends on sum of all sections,
  each section occupy ([value] / sumValues) * 360 degrees
  */
  final List<PieChartSectionData> sections = [
    PieChartSectionData(
      color: CustomColor.lebensmittel,
      value:
          70, //TODO: insert overall Amount of Lebensmittel category Transaction here
      title: AppString.lebensmittel,
    ),
    PieChartSectionData(
      color: CustomColor.drogerie,
      value:
          40, //TODO: insert overall Amount of Drogerie category Transaction here
      title: AppString.drogerie,
    ),
    PieChartSectionData(
      color: CustomColor.shopping,
      value:
          40, //TODO: insert overall Amount of Lebensmittel category Transaction here
      title: AppString.shopping,
    ),
    PieChartSectionData(
      color: CustomColor.unterkunft,
      value: 40, //TODO: insert overall Amount of Unterkunft category Transaction here
      title: AppString.unterkunft,
    ),
    PieChartSectionData(
      color: CustomColor.restaurant,
      value: 40, //TODO: insert overall Amount of Restaurant category Transaction here
      title: AppString.restaurants,
    ),
    PieChartSectionData(
      color: CustomColor.mobility,
      value: 40, //TODO: insert overall Amount of Mobility category Transaction here
      title: AppString.mobility,
    ),
    PieChartSectionData(
      color: CustomColor.entertainment,
      value: 40, //TODO: insert overall Amount of Entertainment category Transaction here
      title: AppString.entertainment,
    ),
    PieChartSectionData(
      color: CustomColor.geschenk,
      value: 40, //TODO: insert overall Amount of Geschenk category Transaction here
      title: AppString.geschenke,
    ),
    PieChartSectionData(
      color: CustomColor.sonstiges,
      value: 40, //TODO: insert overall Amount of Lebensmittel category Transaction here
      title: AppString.sonstiges,
    ),
  ];

  // Generate sections for the pie chart
  List<PieChartSectionData> showingSections() {
    return List.generate(sections.length, (i) {
      return PieChartSectionData(
        color: sections[i].color,
        value: sections[i].value,
        showTitle: false,
        radius: 60,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pie chart
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 0,
              centerSpaceRadius: 80,
              sections: showingSections(),
            ),
          ),
        ),
        
      ],
    );
  }
}

