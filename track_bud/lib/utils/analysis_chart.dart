import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';

// DonutChart widget to display expense or income data
class DonutChart extends StatefulWidget {
  final String selectedOption;

  const DonutChart({Key? key, required this.selectedOption}) : super(key: key);

  @override
  _DonutChartState createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? selectedIndex;
  List<ChartSectionData> expenseSections = [];
  List<ChartSectionData> incomeSections = [];
  double totalAmount = 0.0;
  Map<String, int> transactionCounts = {};

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  // Calculate total amount for the selected option (expense or income)
  void calculateTotalAmount() {
    final sections = widget.selectedOption == 'Ausgaben' ? expenseSections : incomeSections;
    totalAmount = sections.fold(0.0, (sum, section) => sum + section.sectionData.value);
  }

  // Fetch transaction data from Firestore
  Future<void> fetchTransactionData() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance.collection('transactions').where('userId', isEqualTo: user!.uid).get();
    Map<String, double> expenseCategories = {};
    Map<String, double> incomeCategories = {};
    Map<String, int> counts = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final category = data['category'] as String;

      if (amount < 0) {
        expenseCategories[category] = (expenseCategories[category] ?? 0) - amount;
      } else {
        incomeCategories[category] = (incomeCategories[category] ?? 0) + amount;
      }
      counts[category] = (counts[category] ?? 0) + 1;
    }

    setState(() {
      expenseSections = createSections(expenseCategories, true);
      incomeSections = createSections(incomeCategories, false);
      transactionCounts = counts;
      calculateTotalAmount();
    });
  }

  // Create chart sections from category data
  List<ChartSectionData> createSections(Map<String, double> categories, bool isExpense) {
    return categories.entries.map((entry) {
      final category = Categories.values.firstWhere(
        (c) => c.categoryName.toLowerCase() == entry.key.toLowerCase(),
        orElse: () => Categories.sonstiges,
      );
      return ChartSectionData(
        sectionData: PieChartSectionData(
          color: category.color,
          value: entry.value,
          title: category.categoryName,
        ),
        icon: category.icon,
      );
    }).toList();
  }

  // Generate pie chart sections with touch interactivity
  Map<int, PieChartSectionData> showingSections() {
    final sections = widget.selectedOption == 'Ausgaben' ? expenseSections : incomeSections;
    return {
      for (var entry in sections.asMap().entries.where((entry) => entry.value.sectionData.value > 0))
        entry.key: _generatePieChartSectionData(entry.key, entry.value)
    };
  }

  // Helper method to generate individual pie chart section data
  PieChartSectionData _generatePieChartSectionData(int index, ChartSectionData section) {
    final isTouched = index == selectedIndex;
    final opacity = selectedIndex == null || isTouched ? 1.0 : 0.5;

    return PieChartSectionData(
      color: section.sectionData.color.withOpacity(opacity),
      value: section.sectionData.value,
      showTitle: false,
      radius: isTouched ? 70 : 60,
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = widget.selectedOption == 'Ausgaben' ? expenseSections : incomeSections;
    final showingSectionsMap = showingSections();

    return Column(
      children: [
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
                  if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
                    setState(() {
                      final touchedIndex = showingSectionsMap.keys.elementAt(pieTouchResponse!.touchedSection!.touchedSectionIndex);
                      selectedIndex = selectedIndex == touchedIndex ? null : touchedIndex;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        Gap(CustomPadding.defaultSpace),
        Column(children: _buildCategoryTiles(sections)),
      ],
    );
  }

  // Build category tiles based on selection
  List<Widget> _buildCategoryTiles(List<ChartSectionData> sections) {
    if (selectedIndex != null && sections[selectedIndex!].sectionData.value > 0) {
      return [_buildCategoryTile(sections[selectedIndex!], selectedIndex!)];
    } else {
      return sections
          .asMap()
          .entries
          .where((entry) => entry.value.sectionData.value > 0)
          .map((entry) => _buildCategoryTile(entry.value, entry.key))
          .toList();
    }
  }

  // Build individual category tile
  Widget _buildCategoryTile(ChartSectionData section, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CategoryTile(
        color: section.sectionData.color,
        title: section.sectionData.title,
        amount: section.sectionData.value,
        icon: section.icon,
        onTap: () => setState(() => selectedIndex = selectedIndex == index ? null : index),
        totalAmount: totalAmount,
        transactionCount: transactionCounts[section.sectionData.title] ?? 0,
      ),
    );
  }
}

// Data structure for chart sections
class ChartSectionData {
  final PieChartSectionData sectionData;
  final Image icon;

  ChartSectionData({required this.sectionData, required this.icon});
}

// Widget that displays information about each category in the chart
class CategoryTile extends StatelessWidget {
  final Color color;
  final String title;
  final double amount;
  final double totalAmount;
  final Image icon;
  final VoidCallback onTap;
  final int transactionCount;

  const CategoryTile({
    Key? key,
    required this.color,
    required this.title,
    required this.amount,
    required this.icon,
    required this.onTap,
    required this.totalAmount,
    required this.transactionCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: CustomColor.white, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Row(
          children: [
            CategoryIcon(color: color, iconWidget: icon),
            Gap(CustomPadding.mediumSpace),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: TextStyles.regularStyleMedium),
                  Text(
                    '${((amount / totalAmount) * 100).toStringAsFixed(2)}%',
                    style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('${amount.toStringAsFixed(2)}€', style: TextStyles.regularStyleMedium),
                Gap(CustomPadding.mediumSpace),
                Text(
                  '$transactionCount Transaktionen',
                  style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
