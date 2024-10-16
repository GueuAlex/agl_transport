import 'package:flutter/cupertino.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';

class ShippingInfo extends StatelessWidget {
  const ShippingInfo({
    super.key,
    required this.tracteurNum,
    required this.remorqueNum,
    required this.conteneur,
  });
  final String tracteurNum;
  final String remorqueNum;
  final String conteneur;

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: _rowColmun(
                        title: 'N° immatriculation/Tracteur',
                        subtitle: tracteurNum),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _rowColmun(
                              title: 'Remorque',
                              subtitle: remorqueNum.trim().isNotEmpty
                                  ? remorqueNum
                                  : '-'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: _rowColmun(
                            title: 'Conteneur',
                            subtitle:
                                conteneur.trim().isNotEmpty ? conteneur : '-',
                          ),
                        ),
                      )
                    ],
                  )
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
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
              AppText.medium(
                subtitle,
                fontWeight: FontWeight.w500,
                maxLine: 1,
                textOverflow: TextOverflow.ellipsis,
              ),
            ],
          )
        ],
      );
}
