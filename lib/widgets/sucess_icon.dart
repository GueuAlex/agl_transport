import 'package:flutter/material.dart';

import '../config/palette.dart';

Container buildIcon() {
  return Container(
    padding: const EdgeInsets.all(20),
    width: 150,
    height: 150,
    decoration: BoxDecoration(
      color: Palette.primaryColor.withOpacity(0.15),
      shape: BoxShape.circle,
    ),
    child: Container(
      padding: const EdgeInsets.all(20),
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Palette.primaryColor.withOpacity(0.3),
        shape: BoxShape.circle,
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: Palette.primaryColor.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Icon(
            Icons.check,
            size: 25,
            color: Colors.white,
          ),
        ),
      ),
    ),
  );
}
