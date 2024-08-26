import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:track_bud/controller/transaction_controller.dart';
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

  const DonutChart({Key? key, required this.selectedOption}) : super(key: key);

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? selectedIndex;
  Map<String, dynamic> categoryData = {};

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isIncome = widget.selectedOption == 'Einnahmen';
    categoryData =
        await TransactionController().getCategoryTotals(userId, isIncome);
    setState(() {});
  }

  List<ChartSectionData> _getSections() {
    final isIncome = widget.selectedOption == 'Einnahmen';
    final sections = isIncome ? _incomeSections : _expenseSections;

    return sections.map((section) {
      final totalAmount =
          categoryData[section.sectionData.title]?['totalAmount'] ?? 0.0;
      return ChartSectionData(
        sectionData: PieChartSectionData(
          color: section.sectionData.color,
          value: totalAmount,
          title: section.sectionData.title,
        ),
        iconAsset: section.iconAsset,
      );
    }).toList();
  }

  Map<int, PieChartSectionData> _showingSections() {
    final sections = _getSections();
    return Map.fromEntries(
      sections
          .asMap()
          .entries
          .where((entry) => entry.value.sectionData.value > 0)
          .map((entry) {
        final i = entry.key;
        final section = entry.value;
        final isTouched = i == selectedIndex;
        final opacity = selectedIndex == null || isTouched ? 1.0 : 0.5;

        return MapEntry(
          i,
          PieChartSectionData(
            color: section.sectionData.color.withOpacity(opacity),
            value: section.sectionData.value,
            showTitle: false,
            radius: isTouched ? 70 : 60,
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    final showingSectionsMap = _showingSections();

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
              sections: showingSectionsMap.values.toList(),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent &&
                      pieTouchResponse?.touchedSection != null) {
                    setState(() {
                      final touchedIndex = showingSectionsMap.keys.elementAt(
                        pieTouchResponse!.touchedSection!.touchedSectionIndex,
                      );
                      selectedIndex =
                          (selectedIndex == touchedIndex) ? null : touchedIndex;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        SizedBox(height: CustomPadding.defaultSpace),

        // Category names display
        Column(
          children: _buildCategoryTiles(),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryTiles() {
    final sections = _getSections();
    if (selectedIndex != null &&
        sections[selectedIndex!].sectionData.value > 0) {
      final selectedSection = sections[selectedIndex!];
      return [
        _buildCategoryTile(selectedSection),
      ];
    } else {
      return sections
          .where((section) => section.sectionData.value > 0)
          .map((section) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: _buildCategoryTile(section),
              ))
          .toList();
    }
  }

  Widget _buildCategoryTile(ChartSectionData section) {
    final data = categoryData[section.sectionData.title] ?? {};
    return CategoryTile(
      color: section.sectionData.color,
      title: section.sectionData.title,
      percentage: section.sectionData.value,
      icon: section.iconAsset,
      totalAmount: data['totalAmount'] ?? 0.0,
      transactionCount: data['transactionCount'] ?? 0,
      onTap: () => setState(() {
        selectedIndex = selectedIndex == null ? 0 : null;
      }),
    );
  }

  // List of pie chart sections with their properties
  final List<ChartSectionData> _expenseSections = [
    ChartSectionData(
      sectionData: PieChartSectionData(
          color: CustomColor.lebensmittel,
          value: 0,
          title: AppString.lebensmittel),
      iconAsset: AssetImport.shoppingCart,
    ),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.drogerie, value: 0, title: AppString.drogerie),
        iconAsset: AssetImport.drogerie),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.shopping, value: 0, title: AppString.shopping),
        iconAsset: AssetImport.shopping),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.unterkunft,
            value: 0,
            title: AppString.unterkunft),
        iconAsset: AssetImport.home),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.restaurant,
            value: 0,
            title: AppString.restaurants),
        iconAsset: AssetImport.restaurant),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.mobility, value: 0, title: AppString.mobility),
        iconAsset: AssetImport.mobility),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.entertainment,
            value: 0,
            title: AppString.entertainment),
        iconAsset: AssetImport.entertainment),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.geschenk, value: 0, title: AppString.geschenke),
        iconAsset: AssetImport.gift),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.sonstiges, value: 0, title: AppString.sonstiges),
        iconAsset: AssetImport.other),
  ];

  final List<ChartSectionData> _incomeSections = [
    ChartSectionData(
      sectionData: PieChartSectionData(
          color: CustomColor.gehalt, value: 0, title: AppString.workIncome),
      iconAsset: AssetImport.gehalt,
    ),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.geschenk, value: 0, title: AppString.geschenke),
        iconAsset: AssetImport.gift),
    ChartSectionData(
        sectionData: PieChartSectionData(
            color: CustomColor.sonstiges, value: 0, title: AppString.sonstiges),
        iconAsset: AssetImport.other),
  ];
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
  final double totalAmount;
  final int transactionCount;
  final VoidCallback onTap;

  const CategoryTile({
    super.key,
    required this.color,
    required this.title,
    required this.percentage,
    required this.icon,
    required this.totalAmount,
    required this.transactionCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        decoration: BoxDecoration(
            color: CustomColor.white,
            borderRadius: BorderRadius.circular(Constants.buttonBorderRadius)),
        child: ListTile(
          leading: CategoryIcon(
              color: color,
              iconWidget: Image.asset(
                icon,
                width: 25,
                height: 25,
                fit: BoxFit.scaleDown,
              )),
          title: Text(title, style: CustomTextStyle.regularStyleMedium),
          subtitle: Text(
            '${percentage.toStringAsFixed(2)}%',
            style: CustomTextStyle.hintStyleDefault
                .copyWith(fontSize: CustomTextStyle.fontSizeHint),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${totalAmount.toStringAsFixed(2)}€',
                  style: CustomTextStyle.regularStyleMedium),
              SizedBox(height: 8),
              Text('$transactionCount Transaktionen',
                  style: CustomTextStyle.hintStyleDefault
                      .copyWith(fontSize: CustomTextStyle.fontSizeHint)),
            ],
          ),
          minVerticalPadding: CustomPadding.defaultSpace,
        ),
      ),
    );
  }
}
