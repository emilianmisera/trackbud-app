import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/adding_options.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/group_widget.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

// custom bottom navigation bar
class CustomBottomNavigationBar extends StatefulWidget {
  int currentIndex;
  void Function(int) onTap;

  CustomBottomNavigationBar({
    Key? key,
    required this.onTap,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<CustomBottomNavigationBar> createState() => _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> with SingleTickerProviderStateMixin {
  // Animation controller for managing the animation of tab icons
  late AnimationController _animationController;
  // List of animations for each tab
  late List<Animation<double>> _animations;

  @override
  void initState() {
    super.initState();
    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // Create animations for each tab
    _animations = List.generate(
      5,
      (index) => Tween<double>(begin: 1.0, end: 1.1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(0.0, 1.0, curve: Curves.easeInOut),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Dispose of the animation controller when the widget is removed
    _animationController.dispose();
    super.dispose();
  }

  // Handle tab tap event
  void _onTap(int index) {
    setState(() {
      widget.currentIndex = index;
    });
    // Reset and start the animation
    _animationController.reset();
    _animationController.forward();
    // Call the onTap callback
    widget.onTap(index);
  }

  // Build a single navigation item
  Widget _buildNavItem(int index, String active, String inactive) {
    return AnimatedBuilder(
      animation: _animations[index],
      builder: (context, child) {
        return Transform.scale(
          // Scale the active tab
          scale: widget.currentIndex == index ? _animations[index].value : 1.0,
          child: InkWell(
            onTap: () => _onTap(index),
            child: Container(
              // Increased touch area
              width: MediaQuery.of(context).size.width * CustomPadding.navbarButtonwidth,
              height: Constants.height,
              child: Center(
                child: SvgPicture.asset(
                  // Change icon based on whether this tab is selected
                  widget.currentIndex == index ? active : inactive,
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // Method to open a popup window to choose Split Group
  Future _chooseSplitGroup() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            'Gruppe auswählen',
            style: TextStyles.titleStyleMedium,
          ),
          content: Container(
            width: double.maxFinite,
            height: 235,
            child: Column(
              children: [
                Group(
                  onTap: () {
                    Navigator.pop(context); // Close the window
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => AddGroupSplit(
                        isGroup: true,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          insetPadding: EdgeInsets.all(CustomPadding.defaultSpace),
          backgroundColor: CustomColor.backgroundPrimary,
          surfaceTintColor: CustomColor.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.contentBorderRadius),
            ),
          ),
        ),
      );

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.sizeOf(context).height * Constants.addBottomSheetHeight,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: CustomColor.backgroundPrimary,
                borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: CustomPadding.mediumSpace),
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
                    SizedBox(height: CustomPadding.defaultSpace),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => AddTransaction(),
                          );
                        },
                        child: Text('Neue Transaktion hinzufügen')),
                    SizedBox(height: CustomPadding.mediumSpace),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the bottom sheet
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => AddFriendSplit(),
                          );
                        },
                        child: Text('Neuen Freundessplit hinzufügen')),
                    SizedBox(height: CustomPadding.mediumSpace),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _chooseSplitGroup();
                      },
                      child: Text('Neuen Gruppensplit hinzufügen'),
                    ),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      child: BottomAppBar(
        // Styling properties for BottomNavigationBar
        surfaceTintColor: CustomColor.white,
        color: CustomColor.white,
        height: 80,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Overview tab
            _buildNavItem(0, AssetImport.overviewActive, AssetImport.overview),
            // Debts tab
            _buildNavItem(1, AssetImport.debtsActive, AssetImport.debts),
            // Add button (center)
            GestureDetector(
              onTap: () {
                _displayBottomSheet(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width * CustomPadding.navbarButtonwidth,
                child: SvgPicture.asset(AssetImport.addButton),
              ),
            ),
            // Analysis tab
            _buildNavItem(2, AssetImport.analysisActive, AssetImport.analysis),
            // User/Settings tab
            _buildNavItem(3, AssetImport.userActive, AssetImport.user),
          ],
        ),
      ),
    );
  }
}
