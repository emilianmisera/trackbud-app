import 'package:flutter/material.dart';
import 'package:track_bud/utils/buttons_widget.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// Reusable DynamicBottomSheet component
class DynamicBottomSheet extends StatelessWidget {
  // The content to be displayed in the bottom sheet
  final Widget child;
  // Initial size of the bottom sheet as a fraction of screen height
  final double initialChildSize;
  // Minimum size the bottom sheet can be dragged to
  final double minChildSize;
  // Maximum size the bottom sheet can be expanded to
  final double maxChildSize;

  const DynamicBottomSheet({
    Key? key,
    required this.child,
    this.initialChildSize = 0.8, // Default to 80% of screen height
    this.minChildSize = 0.2,     // Can be dragged down to 20% of screen height
    this.maxChildSize = 0.90,    // Can be expanded up to 90% of screen height
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: CustomColor.backgroundPrimary,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            children: [
              SizedBox(height: CustomPadding.mediumSpace),
              Center(
                child: Container( //grabber
                width: 36,
                height: 5,
                decoration: BoxDecoration(
                  color: CustomColor.grabberColor,
                  borderRadius: BorderRadius.all(Radius.circular(100))
                ),
              )), // Instruction for user
              SizedBox(height: CustomPadding.defaultSpace),
              child, // The main content of the bottom sheet
            ],
          ),
        );
      },
    );
  }
}

// adding a new Transaction
class AddTransaction extends StatefulWidget {
  AddTransaction({Key? key}) : super(key: key);

  @override
  State<AddTransaction> createState() => _AddTransactionState();
}

class _AddTransactionState extends State<AddTransaction> {
  Set<String> _selected = {AppString.expense};

  void updateSelected(Set<String> newSelection){
    setState(() {
      _selected = newSelection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DynamicBottomSheet(
      child: SingleChildScrollView(
        child: Padding(
          padding: CustomPadding.screenWidth,
          child: Column(
            children: [
              Center(
                child: Text(AppString.newTransaction, style: CustomTextStyle.regularStyleMedium,),
              ),
              SizedBox(height: CustomPadding.defaultSpace,),
              CustomSegmentControl()
            ],
          ),
        ),
      ),
    );
  }
}