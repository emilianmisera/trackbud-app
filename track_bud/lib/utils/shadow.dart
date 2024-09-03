import 'package:flutter/material.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:track_bud/utils/constants.dart';


//Custom Shadow Widget which is used for all TextFields and Tiles
class CustomShadow extends StatelessWidget {
  final Widget child;
  const CustomShadow({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SimpleShadow(
        color: CustomColor.black,
        opacity: 0.084,
        offset: const Offset(0, 0),
        sigma: 2,
        child: child);
  }
}