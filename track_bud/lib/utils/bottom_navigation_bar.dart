import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/adding_options.dart';
import 'package:track_bud/utils/constants.dart';
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
              height: 60,
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
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => AddTransaction(),
                );
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