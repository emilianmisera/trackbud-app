import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/analysis/chart/category_tile.dart';
import 'package:track_bud/utils/analysis/chart/chart_section_data.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';

class DonutChart extends StatefulWidget {
  final String selectedOption;
  final ValueChanged<String?> onCategorySelected; // New callback for the selected category

  const DonutChart({
    super.key,
    required this.selectedOption,
    required this.onCategorySelected,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? selectedIndex;
  List<ChartSectionData> sections = [];
  double totalAmount = 0.0;
  Map<String, int> transactionCounts = {};

  @override
  void initState() {
    super.initState();
    fetchTransactionData();
  }

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedOption != widget.selectedOption) {
      fetchTransactionData();
    }
  }

  void calculateTotalAmount() {
    totalAmount = sections.fold(0.0, (summary, section) => summary + section.sectionData.value.abs());
  }

  Future<void> fetchTransactionData() async {
    final user = FirebaseAuth.instance.currentUser;
    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: user!.uid)
        .where('type', isEqualTo: widget.selectedOption == 'Ausgaben' ? 'expense' : 'income')
        .get();

    Map<String, double> categories = {};
    Map<String, int> counts = {};

    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final category = data['category'] as String;

      categories[category] = (categories[category] ?? 0) + amount;
      counts[category] = (counts[category] ?? 0) + 1;
    }

    setState(() {
      sections = createSections(categories);
      transactionCounts = counts;
      calculateTotalAmount();
    });
  }

  List<ChartSectionData> createSections(Map<String, double> categories) {
    // Sortiere die Kategorien nach den Werten
    var sortedCategories = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value)); // Absteigend nach Wert sortieren

    return sortedCategories.map((entry) {
      final category = Categories.values.firstWhere(
        (c) => c.categoryName.toLowerCase() == entry.key.toLowerCase(),
        orElse: () => Categories.sonstiges,
      );
      return ChartSectionData(
        sectionData: PieChartSectionData(
          color: category.color,
          value: entry.value.abs(),
          title: category.categoryName,
        ),
        icon: category.icon,
      );
    }).toList();
  }

  Map<int, PieChartSectionData> showingSections() {
    return {for (var entry in sections.asMap().entries) entry.key: _generatePieChartSectionData(entry.key, entry.value)};
  }

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
    final showingSectionsMap = showingSections();

    fetchTransactionData();

    return Column(
      children: [
        AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 80,
              startDegreeOffset: 270,
              sections: showingSectionsMap.values.toList(),
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
                    setState(() {
                      final touchedIndex = showingSectionsMap.keys.elementAt(pieTouchResponse!.touchedSection!.touchedSectionIndex);
                      selectedIndex = selectedIndex == touchedIndex ? null : touchedIndex;

                      // Send the selected category to the parent
                      if (selectedIndex != null) {
                        widget.onCategorySelected(sections[selectedIndex!].sectionData.title);
                      } else {
                        widget.onCategorySelected(null); // No category selected
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ),
        const Gap(CustomPadding.defaultSpace),
        Column(children: _buildCategoryTiles()),
      ],
    );
  }

  List<Widget> _buildCategoryTiles() {
    if (selectedIndex != null && selectedIndex! < sections.length) {
      return [_buildCategoryTile(sections[selectedIndex!], selectedIndex!)];
    } else {
      return sections.asMap().entries.map((entry) => _buildCategoryTile(entry.value, entry.key)).toList();
    }
  }

  Widget _buildCategoryTile(ChartSectionData section, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CategoryTile(
        color: section.sectionData.color,
        title: section.sectionData.title,
        amount: section.sectionData.value,
        icon: section.icon,
        onTap: () => setState(() {
          selectedIndex = selectedIndex == index ? null : index;
          widget.onCategorySelected(selectedIndex != null ? sections[selectedIndex!].sectionData.title : null);
        }),
        totalAmount: totalAmount,
        transactionCount: transactionCounts[section.sectionData.title] ?? 0,
      ),
    );
  }
}
