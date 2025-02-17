import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/utils/plus_button/add_type_selector.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:track_bud/utils/shadow.dart';

// ignore: must_be_immutable
/// custom bottom navigation bar
class CustomBottomNavigationBar extends StatefulWidget {
  final void Function(int) onTap;
  // Index of the currently selected tab
  final int currentIndex;

  const CustomBottomNavigationBar({required this.onTap, required this.currentIndex, super.key});

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
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Create animations for each tab
    _animations = List.generate(
      5,
      (index) => Tween<double>(begin: 1.0, end: 1.1).animate(CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInOut),
      )),
    );
  }

  // Dispose of the animation controller when the widget is removed
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
            borderRadius: BorderRadius.circular(100),
            onTap: () {
              widget.onTap(index);
              // Reset and start the animation
              _animationController.reset();
              _animationController.forward();
            },
            child: SizedBox(
              // Increased touch area
              width: MediaQuery.of(context).size.width * CustomPadding.navbarButtonwidth,
              height: Constants.height,
              child: Center(
                // Change icon based on whether this tab is selected
                child: SvgPicture.asset(widget.currentIndex == index ? active : inactive),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: BottomAppBar(
        // Styling properties for BottomNavigationBar
        surfaceTintColor: defaultColorScheme.surface,
        color: defaultColorScheme.surface,
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
              onTap: () => showModalBottomSheet(context: context, builder: (context) => const AddTypeSelector()),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * CustomPadding.navbarButtonwidth,
                  child: SvgPicture.asset(AssetImport.addButton)),
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
