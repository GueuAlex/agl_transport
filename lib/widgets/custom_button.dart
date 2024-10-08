import 'package:flutter/material.dart';

import '../config/palette.dart';

class CustomButton extends StatelessWidget {
  CustomButton(
      {required this.color,
      required this.width,
      required this.height,
      required this.radius,
      required this.text,
      required this.onPress,
      this.fontsize = 0,
      this.isSetting = false,
      this.textColor = Palette.whiteColor,
      super.key});
  final Color color;
  final double radius, width, height, fontsize;
  final String text;
  final bool isSetting;
  final VoidCallback onPress;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: ElevatedButton(
        onPressed: onPress,
        style: ElevatedButton.styleFrom(
          splashFactory: NoSplash.splashFactory,
          elevation: 0,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: !isSetting
              ? Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(color: textColor)
              : Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: fontsize,
                    color: textColor,
                  ),
        ),
      ),
    );
  }
}
