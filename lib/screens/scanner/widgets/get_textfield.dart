import 'package:flutter/material.dart';

TextField getTextfiel({
  required TextEditingController controller,
  //required String hintext,
}) {
  return TextField(
    controller: controller,
    style: const TextStyle(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
    cursorColor: Colors.black,
    decoration: InputDecoration(
      //label: AppText.medium(hintext),
      border: InputBorder.none,
    ),
  );
}
