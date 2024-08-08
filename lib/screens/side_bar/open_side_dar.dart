import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../config/palette.dart';
import '../gatekeeper_profile/gatekeeper_profile_screen.dart';

class OpenSideBar extends StatelessWidget {
  const OpenSideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(4.5),
          child: Container(
            margin: const EdgeInsets.only(right: 10, left: 5),

            //padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.primaryColor,
            ),
            child: IconButton(
              style: ButtonStyle(
                padding: WidgetStatePropertyAll(
                  EdgeInsets.zero,
                ),
              ),
              /*  onPressed: () {
                return Scaffold.of(context).openDrawer();
              }, */
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => GatekeeperProfileScreen(),
                  fullscreenDialog: true,
                ),
              ),
              icon: SvgPicture.asset(
                "assets/icons/user1.svg",
                width: 16,
                height: 16,
                colorFilter: ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
