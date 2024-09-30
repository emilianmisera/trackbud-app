import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/analysis/chart/category_tile.dart';
import 'package:track_bud/utils/analysis/chart/chart_section_data.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/strings.dart';

/// This Widget shows the chart in the analysis screen.
class DonutChart extends StatefulWidget {
  // income or outcome
  final String selectedOption;
  // Callback for selected category
  final ValueChanged<String?> onCategorySelected;

  const DonutChart({
    super.key,
    required this.selectedOption,
    required this.onCategorySelected,
  });

  @override
  State<DonutChart> createState() => _DonutChartState();
}

class _DonutChartState extends State<DonutChart> {
  int? selectedIndex; // Index of the selected pie slice
  List<ChartSectionData> sections = []; // List of pie chart sections
  double totalAmount = 0.0; // Total amount for all transactions in the chart
  Map<String, int> transactionCounts = {}; // Map to store count of transactions per category

  @override
  void initState() {
    super.initState();
    fetchTransactionData(); // Fetch the data when the widget is first created
  }

  @override
  void didUpdateWidget(DonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the selected option (income/expenses) changes, and refetch data if needed
    if (oldWidget.selectedOption != widget.selectedOption) {
      fetchTransactionData();
    }
  }

  /// Calculate the total transaction amount by summing all section values
  void calculateTotalAmount() {
    totalAmount = sections.fold(0.0, (summary, section) => summary + section.sectionData.value.abs());
  }

  /// Fetch transaction data from Firestore for the current user, based on the selected option (income or expenses)
  Future<void> fetchTransactionData() async {
    final user = FirebaseAuth.instance.currentUser;

    // Fetch transactions where the userId matches and the type is 'expense' or 'income'
    final snapshot = await FirebaseFirestore.instance
        .collection('transactions')
        .where('userId', isEqualTo: user!.uid)
        .where('type', isEqualTo: widget.selectedOption == 'Ausgaben' ? 'expense' : 'income')
        .get();

    Map<String, double> categories = {}; // Holds the total amount for each category
    Map<String, int> counts = {}; // Holds the count of transactions for each category

    // Loop through the transaction documents and accumulate the amounts and counts by category
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final amount = (data['amount'] as num).toDouble();
      final category = data['category'] as String;

      categories[category] = (categories[category] ?? 0) + amount; // Add the amount to the category
      counts[category] = (counts[category] ?? 0) + 1; // Increment the transaction count for the category
    }

    // Update the state with the fetched data
    setState(() {
      sections = createSections(categories); // Create chart sections based on categories and amounts
      transactionCounts = counts; // Store transaction counts
      calculateTotalAmount(); // Recalculate the total transaction amount
    });
  }

  /// Creates pie chart sections from the fetched categories and their amounts
  List<ChartSectionData> createSections(Map<String, double> categories) {
    // Sort categories in descending order by amount
    var sortedCategories = categories.entries.toList()..sort((a, b) => b.value.compareTo(a.value)); // source: ClaudeAI

    // Map sorted categories to chart sections
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

  /// Maps the chart sections to their index, used for generating the PieChartSectionData
  Map<int, PieChartSectionData> showingSections() {
    return {for (var entry in sections.asMap().entries) entry.key: _generatePieChartSectionData(entry.key, entry.value)};
  }

  /// Generates PieChartSectionData for each pie slice, applying opacity if not selected and adjusting the radius
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
    final defaultColorScheme = Theme.of(context).colorScheme;
    // Get the sections to show
    final showingSectionsMap = showingSections();
    // Fetch the data again
    fetchTransactionData();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Chart Display
        AspectRatio(
          aspectRatio: 1.3, // Controls the size of the pie chart
          child: PieChart(
            PieChartData(
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 80,
              startDegreeOffset: 270,
              sections: showingSectionsMap.values.toList(), // Set the chart sections
              pieTouchData: PieTouchData(
                // Handle touch events on the pie chart
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  if (event is FlTapUpEvent && pieTouchResponse?.touchedSection != null) {
                    setState(() {
                      final touchedIndex = showingSectionsMap.keys.elementAt(pieTouchResponse!.touchedSection!.touchedSectionIndex);
                      selectedIndex = selectedIndex == touchedIndex ? null : touchedIndex; // Toggle selection

                      // Send the selected category to the parent widget
                      if (selectedIndex != null) {
                        // Notify parent of selected category
                        widget.onCategorySelected(sections[selectedIndex!].sectionData.title);
                      } else {
                        // No category selected
                        widget.onCategorySelected(null);
                      }
                    });
                  }
                },
              ),
            ),
          ),
        ),
        // List of Category Tiles
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.categories, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
            const Gap(CustomPadding.mediumSpace),
            Column(children: _buildCategoryTiles()),
          ],
        ),
      ],
    );
  }

  /// Builds the list of category tiles shown below the pie chart
  List<Widget> _buildCategoryTiles() {
    // If a category is selected, only show that one tile, otherwise show all
    if (selectedIndex != null && selectedIndex! < sections.length) {
      return [_buildCategoryTile(sections[selectedIndex!], selectedIndex!)];
    } else {
      return sections.asMap().entries.map((entry) => _buildCategoryTile(entry.value, entry.key)).toList();
    }
  }

  /// Builds a single category tile with color, title, amount, and icon
  Widget _buildCategoryTile(ChartSectionData section, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: CategoryTile(
        color: section.sectionData.color,
        title: section.sectionData.title,
        amount: section.sectionData.value,
        icon: section.icon,
        onTap: () => setState(() {
          // Toggle selection and notify the parent widget
          selectedIndex = selectedIndex == index ? null : index;
          widget.onCategorySelected(selectedIndex != null ? sections[selectedIndex!].sectionData.title : null);
        }),
        totalAmount: totalAmount,
        transactionCount: transactionCounts[section.sectionData.title] ?? 0,
      ),
    );
  }
}
