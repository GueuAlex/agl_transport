import 'package:flutter/cupertino.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';

class IconRow extends StatelessWidget {
  const IconRow({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    //required this.onTap,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  //final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Palette.primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Icon(icon),
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText.medium(
                  title,
                  fontWeight: FontWeight.w500,
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                AppText.medium(
                  subtitle,
                  fontWeight: FontWeight.w400,
                  maxLine: 1,
                  textOverflow: TextOverflow.ellipsis,
                  fontSize: 12,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(
              CupertinoIcons.chevron_right,
              size: 16,
              color: Color.fromARGB(255, 50, 50, 50),
            ),
          )
        ],
      ),
    );
  }
}
