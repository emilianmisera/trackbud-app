import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/adding_options.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfield_widget.dart';

// CustomBottomNavigationBar: A stateful widget for a custom bottom navigation bar
// ignore: must_be_immutable
class CustomBottomNavigationBar extends StatefulWidget {
  // Current index of the selected tab
  int currentIndex;
  // Callback function to handle tab selection
  void Function(int) onTap;

  CustomBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: BottomAppBar(
        // Styling properties for the BottomAppBar
        surfaceTintColor: CustomColor.white,
        color: CustomColor.white,
        height: 80,
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Overview tab
              MaterialButton(
                onPressed: () => widget.onTap(0),
                minWidth: MediaQuery.sizeOf(context).width *
                    CustomPadding.navbarButtonwidth,
                child: SvgPicture.asset(
                  // Change icon based on whether this tab is selected
                  widget.currentIndex == 0
                      ? AssetImport.overviewActive
                      : AssetImport.overview,
                ),
              ),
              // Debts tab
              MaterialButton(
                onPressed: () => widget.onTap(1),
                minWidth: MediaQuery.sizeOf(context).width *
                    CustomPadding.navbarButtonwidth,
                child: SvgPicture.asset(
                  widget.currentIndex == 1
                      ? AssetImport.debtsActive
                      : AssetImport.debts,
                ),
              ),
              // Add button (center)
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    backgroundColor: Colors.transparent,
                    builder: (context) => AddTransaction(),
                  );
                },
                child: Container( // add Button
                    width: MediaQuery.sizeOf(context).width *
                        CustomPadding.navbarButtonwidth,
                    child: SvgPicture.asset(AssetImport.addButton)),
              ),
              // Analysis tab
              MaterialButton(
                onPressed: () => widget.onTap(2),
                minWidth: MediaQuery.sizeOf(context).width *
                    CustomPadding.navbarButtonwidth,
                child: SvgPicture.asset(
                  widget.currentIndex == 2
                      ? AssetImport.analysisActive
                      : AssetImport.analysis,
                ),
              ),
              // User/Settings tab
              MaterialButton(
                onPressed: () => widget.onTap(3),
                minWidth: MediaQuery.sizeOf(context).width *
                    CustomPadding.navbarButtonwidth,
                child: SvgPicture.asset(
                  widget.currentIndex == 3
                      ? AssetImport.userActive
                      : AssetImport.user,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
