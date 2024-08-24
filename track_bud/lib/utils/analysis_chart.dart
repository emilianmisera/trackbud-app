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
  final String selectedOption;

  const DonutChart({super.key, required this.selectedOption});

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
  final List<ChartSectionData> expenseSections = [
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.lebensmittel,
          value:
              70, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.lebensmittel,
        ),
        iconAsset: AssetImport.shoppingCart),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.drogerie,
          value:
              40, //TODO: insert overall Amount of Drogerie category Transaction here
          title: AppString.drogerie,
        ),
        iconAsset: AssetImport.drogerie),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.shopping,
          value:
              70, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.shopping,
        ),
        iconAsset: AssetImport.shopping),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.unterkunft,
          value:
              0, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.unterkunft,
        ),
        iconAsset: AssetImport.home),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.restaurant,
          value:
              0, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.restaurants,
        ),
        iconAsset: AssetImport.restaurant),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.mobility,
          value:
              5, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.mobility,
        ),
        iconAsset: AssetImport.mobility),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.entertainment,
          value:
              0, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.entertainment,
        ),
        iconAsset: AssetImport.entertainment),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.geschenk,
          value:
              00, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.geschenke,
        ),
        iconAsset: AssetImport.gift),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.sonstiges,
          value:
              0, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.sonstiges,
        ),
        iconAsset: AssetImport.other),
  ];

  final List<ChartSectionData> incomeSections = [
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.gehalt,
          value:
              70, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.workIncome,
        ),
        iconAsset: AssetImport.gehalt),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.geschenk,
          value:
              10, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.geschenke,
        ),
        iconAsset: AssetImport.gift),
    ChartSectionData(
        sectionData: PieChartSectionData(
          color: CustomColor.sonstiges,
          value:
              70, //TODO: insert overall Amount of Lebensmittel category Transaction here
          title: AppString.sonstiges,
        ),
        iconAsset: AssetImport.other),
  ];

  // Generate sections for the pie chart
  List<PieChartSectionData> showingSections() {
    // if Expense Dropdown is selected, the expenseSection will be displayed,
    // if Income Dropdown is selected, incomeSection will be displayed
    final sections =
        widget.selectedOption == 'Ausgaben' ? expenseSections : incomeSections;
    return List.generate(sections.length, (i) {
      if (i >= sections.length || sections[i].sectionData.value == 0)
        return PieChartSectionData(value: 0);
      final isTouched = i == selectedIndex;
      // Set opacity to 50% for non-selected sections when a section is selected
      final opacity = selectedIndex == null || isTouched ? 1.0 : 0.5;

      return PieChartSectionData(
        color: sections[i].sectionData.color.withOpacity(opacity),
        value: sections[i].sectionData.value,
        showTitle: false,
        // Increase radius of the selected section
        radius: isTouched ? 70 : 60,
      );
    })
        .where((section) => section.value > 0)
        .toList(); // Only include sections with value > 0
  }

  @override
  Widget build(BuildContext context) {
    final sections =
        widget.selectedOption == 'Ausgaben' ? expenseSections : incomeSections;

    return Column(
      children: [
        // Pie chart
        AspectRatio(
          // control the shape of the container that holds the pie chart
          aspectRatio: 1.3, // Set the aspect ratio of the chart container
          child: PieChart(
            PieChartData(
              borderData:
                  FlBorderData(show: false), // Hide the border of the chart
              sectionsSpace: 0, // No space between pie sections
              centerSpaceRadius:
                  80, // Set the radius of the empty space in the center
              sections: showingSections(), // Get the sections data
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
                      if (touchedIndex < 0 ||
                          touchedIndex >= expenseSections.length) {
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
                  if (sections[selectedIndex!].sectionData.value > 0)
                    CategoryTile(
                      color: sections[selectedIndex!].sectionData.color,
                      title: sections[selectedIndex!].sectionData.title,
                      percentage: sections[selectedIndex!].sectionData.value,
                      icon: sections[selectedIndex!].iconAsset,
                    )
                ]
              : sections
                  .where((section) =>
                      section.sectionData.value >
                      0) // Only include sections with value > 0
                  .map((section) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: CategoryTile(
                        color: section.sectionData.color,
                        title: section.sectionData.title,
                        percentage: section.sectionData.value,
                        icon: section.iconAsset,
                      )))
                  .toList(),
        ),
      ],
    );
  }
}

class ChartSectionData {
  final PieChartSectionData sectionData;
  final String iconAsset;

  ChartSectionData({required this.sectionData, required this.iconAsset});

  Widget get icon => Image.asset(
        iconAsset,
        width: 25,
        height: 25,
        fit: BoxFit.scaleDown,
      );
}

// Widget that displays Information about the chart
class CategoryTile extends StatelessWidget {
  final Color color;
  final String title;
  final double percentage;
  final String icon;
  const CategoryTile(
      {super.key,
      required this.color,
      required this.title,
      required this.percentage,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: CustomColor.white,
          borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
      child: ListTile(
        // Icon
        leading: CategoryIcon(
            color: color,
            iconWidget: Image.asset(
              icon,
              width: 25,
              height: 25,
              fit: BoxFit.scaleDown,
            )), //TODO: Add Icons
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
