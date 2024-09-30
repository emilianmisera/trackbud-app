import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';

/// Reusable DynamicBottomSheet component
class AddEntryModal extends StatelessWidget {
  final Widget child;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
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
    final defaultColorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: defaultColorScheme.onSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Constants.contentBorderRadius)),
          ),
          child: Column(
            children: [
              const Gap(CustomPadding.mediumSpace),
              // grabber
              Center(
                child: Container(
                    width: 36,
                    height: 5,
                    decoration: const BoxDecoration(
                      color: CustomColor.grabberColor,
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    )),
              ),
              const Gap(CustomPadding.defaultSpace),
              // The main content of the bottom sheet
              Expanded(child: SingleChildScrollView(controller: scrollController, child: child)),
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
