import 'package:flutter/material.dart';

Widget makeTransactionsIcon() {
  const width = 4.5;
  const space = 3.5;
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Container(
        width: width,
        height: 5,
        color: Color.fromARGB(255, 40, 46, 58).withOpacity(0.4),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 12,
        color: Color.fromARGB(255, 40, 46, 58).withOpacity(0.8),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 20,
        color: Color.fromARGB(255, 40, 46, 58).withOpacity(1),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 12,
        color: Color.fromARGB(255, 40, 46, 58).withOpacity(0.8),
      ),
      const SizedBox(
        width: space,
      ),
      Container(
        width: width,
        height: 5,
        color: Color.fromARGB(255, 40, 46, 58).withOpacity(0.4),
      ),
    ],
  );
}
