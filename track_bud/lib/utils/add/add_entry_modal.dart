import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

// This File shows following Widgets:
// 1) Reusuble scrollable DynamicBottomSheet that is only used for adding a new Transaction, Friendsplit & Groupsplit
// 2) Add a new Transaction
// 3) Add a new Split

// Reusable DynamicBottomSheet component
class AddEntryModal extends StatelessWidget {
  // The content to be displayed in the bottom sheet
  final Widget child;
  // Initial size of the bottom sheet as a fraction of screen height
  final double initialChildSize;
  // Minimum size the bottom sheet can be dragged to
  final double minChildSize;
  // Maximum size the bottom sheet can be expanded to
  final double maxChildSize;
  // text of the button
  final String buttonText;
  final VoidCallback onButtonPressed;

  final bool isButtonEnabled;

  const AddEntryModal({
    required this.child,
    this.initialChildSize = 0.76,
    this.minChildSize = 0.3,
    this.maxChildSize = 0.95,
    required this.buttonText,
    required this.onButtonPressed,
    required this.isButtonEnabled,
    super.key,
  });

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
            borderRadius: BorderRadius.vertical(top: Radius.circular(Constants.contentBorderRadius)),
          ),
          child: Column(
            children: [
              Gap(CustomPadding.mediumSpace),
              Center(
                child: Container(
                  // grabber
                  width: 36,
                  height: 5,
                  decoration: BoxDecoration(
                    color: CustomColor.grabberColor,
                    borderRadius: BorderRadius.all(Radius.circular(100)),
                  ),
                ),
              ),
              Gap(CustomPadding.defaultSpace),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: child, // The main content of the bottom sheet
                ),
              ),
              // Button to add the transaction
              Padding(
                padding: EdgeInsets.only(
                    left: CustomPadding.mediumSpace,
                    right: CustomPadding.mediumSpace,
                    bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace),
                child: ElevatedButton(onPressed: isButtonEnabled ? onButtonPressed : null, child: Text(buttonText)),
              )
            ],
          ),
        );
      },
    );
  }
}
