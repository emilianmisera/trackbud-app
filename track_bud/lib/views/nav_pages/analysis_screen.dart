import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/controller/user_controller.dart';
import 'package:track_bud/utils/analysis_chart.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/widgets/transaction_list.dart';

// Main screen for displaying financial analysis
class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final UserController _userController = UserController();
  double _currentBalance = 0.00;
  String _selectedOption = 'Ausgaben'; // Default option is 'Expenses'
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    //_loadCurrentBankAccountInfo(); // Uncomment to load bank info on initialization
  }

  // Future method to load current bank account balance
  /*Future<void> _loadCurrentBankAccountInfo() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    try {
      double currentBalance =
          await _userController.getBankAccountBalance(userId);
      setState(() {
        _currentBalance = currentBalance;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Fehler beim Laden des Bankkontostands: $e"),
        ),
      );
    }
  }*/

  // Updates chart data when a new category or option is selected
  void _updateChartData() {
    setState(() {
      _selectedCategory = null; // Reset category when chart is updated
    });
  }

  // Handles category selection for the chart
  void _onCategorySelected(String category) {
    setState(() {
      _selectedCategory = category == _selectedCategory ? null : category;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Determine the title and color for the InfoTile based on the selected option
    String _infoTileTitle = _selectedOption == 'Ausgaben' ? 'ausgegeben' : 'erhalten';
    Color _infoTileColor = _selectedOption == 'Ausgaben' ? CustomColor.red : CustomColor.green;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          // Padding to ensure spacing around the content
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InfoTile(title: AppTexts.balance, amount: '${_currentBalance.toStringAsFixed(2)}', color: CustomColor.bluePrimary),
              Gap(CustomPadding.mediumSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InfoTile(
                    title: _infoTileTitle,
                    amount: 'amount', // Placeholder text, replace with actual amount
                    color: _infoTileColor,
                    width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,
                  ),
                  CustomDropDown(
                    list: ['Ausgaben', 'Einnahmen'],
                    width: MediaQuery.sizeOf(context).width / 2 - Constants.infoTileSpace,
                    height: 88,
                    onChanged: (value) {
                      setState(() {
                        _selectedOption = value;
                        _selectedCategory = null;
                      });
                    },
                  ),
                ],
              ),
              Gap(CustomPadding.defaultSpace),
              DonutChart(
                  selectedOption: _selectedOption,
                  selectedCategory: _selectedCategory,
                  key: ValueKey(_selectedOption),
                  onCategorySelected: _onCategorySelected),
              Gap(CustomPadding.defaultSpace),
              Text(
                AppTexts.history,
                style: TextStyles.regularStyleMedium,
              ),
              Gap(CustomPadding.mediumSpace),
              TransactionList(
                  onTransactionChangeCallback: _updateChartData, selectedOption: _selectedOption, selectedCategory: _selectedCategory),
            ],
          ),
        ),
      ),
    );
  }
}
