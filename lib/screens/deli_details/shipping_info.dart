import 'package:flutter/cupertino.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';

class ShippingInfo extends StatelessWidget {
  const ShippingInfo({
    super.key,
    required this.tracteurNum,
    required this.remorqueNum,
  });
  final String tracteurNum;
  final String remorqueNum;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          width: 1,
          color: Palette.separatorColor,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                children: [
                  _rowColmun(title: 'Tracteur', subtitle: tracteurNum),
                  const SizedBox(
                    height: 10,
                  ),
                  _rowColmun(title: 'Remorque', subtitle: remorqueNum),
                ],
              ),
            ),
            Transform.rotate(
              angle: 0,
              child: Image.asset(
                'assets/images/shipping-car.png',
                width: 100,
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _rowColmun({required String title, required String subtitle}) => Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(3),
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Palette.primaryColor,
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText.small(
                title,
                color: Color.fromARGB(255, 134, 134, 134),
                fontWeight: FontWeight.w600,
              ),
              AppText.medium(
                subtitle,
                fontWeight: FontWeight.w500,
              ),
            ],
          )
        ],
      );
}
