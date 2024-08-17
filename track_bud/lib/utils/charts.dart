import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';

// Background of Charts
class ChartTile extends StatelessWidget {
  final Widget chartChild;
  const ChartTile({super.key, required this.chartChild});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      padding: EdgeInsets.only(
          top: CustomPadding.bigSpace, bottom: CustomPadding.defaultSpace),
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
  // Index of the selected section, null if no section is selected
  int? selectedIndex;

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
      value:
          40, //TODO: insert overall Amount of Unterkunft category Transaction here
      title: AppString.unterkunft,
    ),
    PieChartSectionData(
      color: CustomColor.restaurant,
      value:
          40, //TODO: insert overall Amount of Restaurant category Transaction here
      title: AppString.restaurants,
    ),
    PieChartSectionData(
      color: CustomColor.mobility,
      value:
          40, //TODO: insert overall Amount of Mobility category Transaction here
      title: AppString.mobility,
    ),
    PieChartSectionData(
      color: CustomColor.entertainment,
      value:
          40, //TODO: insert overall Amount of Entertainment category Transaction here
      title: AppString.entertainment,
    ),
    PieChartSectionData(
      color: CustomColor.geschenk,
      value:
          40, //TODO: insert overall Amount of Geschenk category Transaction here
      title: AppString.geschenke,
    ),
    PieChartSectionData(
      color: CustomColor.sonstiges,
      value:
          40, //TODO: insert overall Amount of Lebensmittel category Transaction here
      title: AppString.sonstiges,
    ),
  ];

  // Generate sections for the pie chart
  List<PieChartSectionData> showingSections() {
    return List.generate(sections.length, (i) {
      if (i >= sections.length) return PieChartSectionData();
      final isTouched = i == selectedIndex;
      // Set opacity to 50% for non-selected sections when a section is selected
      final opacity = selectedIndex == null || isTouched ? 1.0 : 0.5;

      return PieChartSectionData(
        color: sections[i].color.withOpacity(opacity),
        value: sections[i].value,
        showTitle: false,
        // Increase radius of the selected section
        radius: isTouched ? 70 : 60,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Pie chart
        AspectRatio( // control the shape of the container that holds the pie chart
          aspectRatio: 1.3, // Set the aspect ratio of the chart container
          child: PieChart(
            PieChartData(
              borderData:
                  FlBorderData(show: false), // Hide the border of the chart
              sectionsSpace: 0, // No space between pie sections
              centerSpaceRadius:
                  80, // Set the radius of the empty space in the center
              sections:
                  showingSections(), // Get the sections data
              pieTouchData: PieTouchData(
                // Handle touch events on the pie chart
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent) {
                    // Only react to the TouchUp event
                    setState(() {
                      if (pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        return; // Exit if no valid touch response
                      }
                      final touchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                      if (touchedIndex < 0 || touchedIndex >= sections.length) {
                        return; // Exit if touched index is out of range
                      }
                      if (selectedIndex == touchedIndex) {
                        selectedIndex = null; // Deselect if already selected
                      } else {
                        selectedIndex =
                            touchedIndex; // Select the touched section
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(
          height: CustomPadding.defaultSpace,
        ),
        // Category names display
        Column(
          children: selectedIndex != null && selectedIndex! < sections.length
              ? [
                  // Display only the selected category name if one is selected
                  CategoryTile(
                    color: sections[selectedIndex!].color,
                    title: sections[selectedIndex!].title,
                    percentage: sections[selectedIndex!].value,
                  )
                ]
              : // Display all category names if no category is selected
              sections.map((section) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: CategoryTile(
                          color: section.color,
                          title: section.title,
                          percentage: section.value,
                        ))).toList(),
        ),
      ],
    );
  }
}

// Widget that displays Information about the chart
class CategoryTile extends StatelessWidget {
  final Color color;
  final String title;
  final double percentage;
  const CategoryTile(
      {super.key,
      required this.color,
      required this.title,
      required this.percentage});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
      child: ListTile(
        // Icon
        leading: CategoryIcon(color: color, icon: AssetImport.appleLogo), //TODO: Add Icons
        // Title of Transaction
        title: Text(
          title,
          style: CustomTextStyle.regularStyleMedium,
        ),
        // Timestamp
        subtitle: Text(
          '$percentage%',
          style: CustomTextStyle.hintStyleDefault
              .copyWith(fontSize: CustomTextStyle.fontSizeHint),
        ),
        // Amount
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '100€', //TODO: implement total Amount of category expense/income
              style: CustomTextStyle.regularStyleMedium,
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              '- Transaktionen', //TODO: implement length of list of amount of transactions of specific categroy
              style: CustomTextStyle.hintStyleDefault
                  .copyWith(fontSize: CustomTextStyle.fontSizeHint),
            ),
          ],
        ),
        minVerticalPadding: CustomPadding.defaultSpace,
      ),
    );
  }
}
