import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/transaction_provider.dart';
import 'package:track_bud/utils/analysis/chart/analysis_chart.dart';
import 'package:track_bud/utils/button_widgets/dropdown.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/widgets/transaction_list.dart';

/// This is the Analysis Screen
/// It is one of the Naviagtion Pages
/// It displays user transaction data with a chart
/// and the User sees his Transaction History
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String _selectedOption = 'Ausgaben'; // Default option is 'Expenses'
  String? _selectedCategory; // Track the selected category

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final transactionProvider = Provider.of<TransactionProvider>(context, listen: false);
      transactionProvider.initializeBalance();
      transactionProvider.calculateTotalAmount('expense');
    });
  }

  @override
  Widget build(BuildContext context) {
    String infoTileTitle = _selectedOption == 'Ausgaben' ? 'ausgegeben' : 'erhalten';
    Color infoTileColor = _selectedOption == 'Ausgaben' ? CustomColor.red : CustomColor.green;
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Consumer<TransactionProvider>(
        builder: (context, transactionProvider, child) {
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace,
                  left: CustomPadding.defaultSpace,
                  right: CustomPadding.defaultSpace),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InfoTile(
                      title: AppTexts.balance,
                      amount: transactionProvider.currentBalance.toStringAsFixed(2),
                      color: CustomColor.bluePrimary),
                  const Gap(CustomPadding.mediumSpace),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InfoTile(
                          title: infoTileTitle,
                          amount: transactionProvider.totalAmount.toStringAsFixed(2),
                          color: infoTileColor,
                          width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace),
                      CustomDropDown(
                        list: const ['Ausgaben', 'Einnahmen'],
                        width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,
                        height: 96,
                        onChanged: (value) {
                          setState(() {
                            _selectedOption = value;
                            transactionProvider.calculateTotalAmount(_selectedOption == 'Ausgaben' ? 'expense' : 'income');
                          });
                        },
                      ),
                    ],
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  DonutChart(
                    selectedOption: _selectedOption,
                    onCategorySelected: (category) {
                      setState(
                        () {
                          _selectedCategory = category; // Track selected category
                        },
                      );
                    },
                  ),
                  const Gap(CustomPadding.defaultSpace),
                  Text(AppTexts.history, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                  const Gap(CustomPadding.mediumSpace),
                  TransactionHistoryList(
                      // Pass the selected category here
                      transactionType: _selectedOption == 'Ausgaben' ? 'expense' : 'income',
                      selectedCategory: _selectedCategory),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
