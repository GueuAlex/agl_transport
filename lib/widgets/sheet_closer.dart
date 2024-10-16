import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SheetCloser extends StatelessWidget {
  const SheetCloser({super.key, this.paddingV = 10});
  final double paddingV;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: paddingV),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(),
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 237, 237, 237),
              shape: BoxShape.circle,
            ),
            child: InkWell(
              onTap: () => Navigator.pop(context),
              child: Center(
                child: Icon(
                  CupertinoIcons.xmark,
                  size: 16,
                  color: Color.fromARGB(255, 118, 118, 118),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
