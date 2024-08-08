import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../config/app_text.dart';

Container tagContainer({
  Color color = const Color.fromARGB(255, 6, 53, 101),
  IconData icon = CupertinoIcons.checkmark_circle_fill,
  bool withIcon = true,
  String text = '10+ expérience',
  bool isWhiteBg = false,
}) =>
    !isWhiteBg
        ? Container(
            margin: const EdgeInsets.only(bottom: 5, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              //color: Color.fromARGB(255, 2, 161, 189),
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 190, 190, 190).withOpacity(1),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
                BoxShadow(
                  color: Color.fromARGB(255, 190, 190, 190).withOpacity(1),
                  blurRadius: 3,
                  spreadRadius: 0,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: withIcon
                ? Row(
                    children: [
                      Icon(
                        icon,
                        size: 13,
                        color: color,
                      ),
                      SizedBox(width: 5),
                      AppText.small(
                        text,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  )
                : AppText.small(
                    text,
                    color: color,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
          )
        : Container(
            margin: const EdgeInsets.only(bottom: 5, right: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              //color: Color.fromARGB(255, 2, 161, 189),
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(5),
            ),
            child: withIcon
                ? Row(
                    children: [
                      Icon(
                        icon,
                        size: 13,
                        color: color,
                      ),
                      SizedBox(width: 5),
                      AppText.small(
                        text,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                    ],
                  )
                : AppText.small(
                    text,
                    color: color,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
          );
