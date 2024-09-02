import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
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
      padding: EdgeInsets.only(top: CustomPadding.bigSpace, bottom: CustomPadding.defaultSpace),
      decoration: BoxDecoration(
        color: CustomColor.white,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      child: chartChild,
    );
  }
}

// Donut Chart in Analysis Screen
class DonutChart extends StatefulWidget {
  final String selectedOption;
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const DonutChart({Key? key, required this.selectedOption, required this.selectedCategory, required this.onCategorySelected})
      : super(key: key);

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

  @override
  void didUpdateWidget(covariant DonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.selectedOption != widget.selectedOption || oldWidget.selectedCategory != widget.selectedCategory) {
      _loadData();
      setState(() {
        selectedIndex = widget.selectedCategory == null
            ? null
            : _getSections().indexWhere((section) => section.sectionData.title == widget.selectedCategory);
      });
    }
  }

  Future<void> _loadData() async {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final isIncome = widget.selectedOption == 'Einnahmen';
    try {
      categoryData = await TransactionController().getCategoryTotals(userId, isIncome);
      if (mounted) {
        // Ensure the widget is still mounted before calling setState
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Handle error state here, maybe show an error message
        });
      }
    }
  }

  List<ChartSectionData> _getSections() {
    final isIncome = widget.selectedOption == 'Einnahmen';
    final sections = isIncome ? _incomeSections : _expenseSections;

    final sortedSections = sections
        .map((section) {
          final totalAmount = categoryData[section.sectionData.title]?['totalAmount'] ?? 0.0;
          return ChartSectionData(
            sectionData: PieChartSectionData(
              color: section.sectionData.color,
              value: totalAmount,
              title: section.sectionData.title,
            ),
            iconAsset: section.iconAsset,
          );
        })
        .toList()
        .where((section) => section.sectionData.value > 0)
        .toList();

    sortedSections.sort((a, b) => b.sectionData.value.compareTo(a.sectionData.value));

    return sortedSections;
  }

  Map<int, PieChartSectionData> _showingSections() {
    final sections = _getSections();
    return Map.fromEntries(
      sections.asMap().entries.where((entry) => entry.value.sectionData.value > 0).map((entry) {
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
    _loadData();
    if (categoryData.isEmpty) {
      return Center(
        child: CircularProgressIndicator(), //
      );
    }
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
              startDegreeOffset: 270,
              sections: showingSectionsMap.values.toList(),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
                    final touchedIndex = showingSectionsMap.keys.elementAt(
                      pieTouchResponse!.touchedSection!.touchedSectionIndex,
                    );
                    final sectionTitle = _getSections()[touchedIndex].sectionData.title;
                    setState(() {
                      selectedIndex = (selectedIndex == touchedIndex) ? null : touchedIndex;
                    });
                    widget.onCategorySelected(sectionTitle);
                  }
                },
              ),
            ),
          ),
        ),
        Gap(CustomPadding.defaultSpace),

        // Category names display
        Column(
          children: _buildCategoryTiles(),
        ),
      ],
    );
  }

  List<Widget> _buildCategoryTiles() {
    final sections = _getSections();

    if (selectedIndex != null && sections[selectedIndex!].sectionData.value > 0) {
      final selectedSection = sections[selectedIndex!];
      return [
        _buildCategoryTile(selectedSection, selectedIndex!),
      ];
    } else {
      // Sortiere die Abschnitte nach totalAmount in absteigender Reihenfolge
      final sortedSections = sections.where((section) => section.sectionData.value > 0).toList()
        ..sort((a, b) => b.sectionData.value.compareTo(a.sectionData.value));

      return sortedSections
          .map((section) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: _buildCategoryTile(section, sections.indexOf(section)),
              ))
          .toList();
    }
  }

  Widget _buildCategoryTile(ChartSectionData section, int index) {
    final data = categoryData[section.sectionData.title] ?? {};
    final totalSum = categoryData['totalSum'] ?? 0.0;
    final totalAmount = data['totalAmount'] ?? 0.0;

    // Calculate the percentage
    final percentage = totalSum > 0 ? (totalAmount / totalSum) * 100 : 0.0;

    return CategoryTile(
      color: section.sectionData.color,
      title: section.sectionData.title,
      percentage: percentage, // Use the calculated percentage
      icon: section.iconAsset,
      totalAmount: totalAmount,
      transactionCount: data['transactionCount'] ?? 0,
      onTap: () {
        setState(() {
          selectedIndex = selectedIndex == index ? null : index;
        });
        widget.onCategorySelected(section.sectionData.title);
      },
    );
  }

  // List of pie chart sections with their properties
  final List<ChartSectionData> _expenseSections = [
    ChartSectionData(
      sectionData: PieChartSectionData(color: CustomColor.lebensmittel, title: AppTexts.lebensmittel),
      iconAsset: AssetImport.shoppingCart,
    ),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.drogerie, title: AppTexts.drogerie), iconAsset: AssetImport.drogerie),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.shopping, title: AppTexts.shopping), iconAsset: AssetImport.shopping),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.unterkunft, title: AppTexts.unterkunft), iconAsset: AssetImport.home),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.restaurant, title: AppTexts.restaurants), iconAsset: AssetImport.restaurant),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.mobility, title: AppTexts.mobility), iconAsset: AssetImport.mobility),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.entertainment, title: AppTexts.entertainment),
        iconAsset: AssetImport.entertainment),
    ChartSectionData(sectionData: PieChartSectionData(color: CustomColor.geschenk, title: AppTexts.geschenke), iconAsset: AssetImport.gift),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.sonstiges, title: AppTexts.sonstiges), iconAsset: AssetImport.other),
  ];

  final List<ChartSectionData> _incomeSections = [
    ChartSectionData(
      sectionData: PieChartSectionData(color: CustomColor.gehalt, title: AppTexts.workIncome),
      iconAsset: AssetImport.gehalt,
    ),
    ChartSectionData(sectionData: PieChartSectionData(color: CustomColor.geschenk, title: AppTexts.geschenke), iconAsset: AssetImport.gift),
    ChartSectionData(
        sectionData: PieChartSectionData(color: CustomColor.sonstiges, title: AppTexts.sonstiges), iconAsset: AssetImport.other),
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
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: ListTile(
          leading: CategoryIcon(
              color: color,
              iconWidget: Image.asset(
                icon,
                width: 25,
                height: 25,
                fit: BoxFit.scaleDown,
              )),
          title: Text(title, style: TextStyles.regularStyleMedium),
          subtitle: Text(
            '${percentage.toStringAsFixed(1)}%',
            style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${totalAmount.toStringAsFixed(2)}€', style: TextStyles.regularStyleMedium),
              Gap(8),
              Text('$transactionCount Transaktionen', style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint)),
            ],
          ),
          minVerticalPadding: CustomPadding.defaultSpace,
        ),
      ),
    );
  }
}
