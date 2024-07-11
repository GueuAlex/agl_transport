import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../config/palette.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    super.key,
    required this.child,
    required this.isOn,
  });

  final String child;
  final bool isOn;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SvgPicture.asset(
        child,
        height: 15,
        width: 15,
        colorFilter: ColorFilter.mode(
          isOn ? Palette.appPrimaryColor : Palette.primaryColor,
          BlendMode.srcIn,
        ),
      ),
    );
  }
}
