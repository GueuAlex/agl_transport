import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scanner/config/palette.dart';
import 'package:scanner/screens/scanner/widgets/infos_column.dart';
import 'package:scanner/widgets/copy_rigtht.dart';
import 'package:scanner/widgets/custom_button.dart';

import '../../config/app_text.dart';

class GatekeeperProfileScreen extends StatelessWidget {
  static const routeName = 'gatekeeperProfileScreen';
  const GatekeeperProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: AppText.medium(
            'Double clic pour quitter',
            color: Colors.grey,
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  bottom: BorderSide(
                    width: 0.8,
                    color: Palette.separatorColor,
                  ),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      width: double.infinity,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.amber,
                        image: DecorationImage(
                          image: AssetImage('assets/images/agl-banner.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        color: Colors.black.withOpacity(
                          0.15,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 10,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Palette.separatorColor,
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 4,
                          color: Colors.white,
                        ),
                        image: DecorationImage(
                          image: AssetImage('assets/images/security.jpg'),
                          fit: BoxFit.cover,
                          //scale: 0.1,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 110,
                    right: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width - 100,
                      height: 150,
                      padding: const EdgeInsets.only(left: 10, top: 10),
                      //color: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _tagContainer(),
                                _tagContainer(
                                  icon: CupertinoIcons.arrow_up,
                                  text: 'Entrée G',
                                  color: Color.fromARGB(255, 157, 3, 121),
                                ),
                                _tagContainer(
                                  icon: CupertinoIcons.arrow_up,
                                  text: 'Team Leader',
                                  color: Color.fromARGB(255, 2, 110, 149),
                                  withIcon: false,
                                ),
                              ],
                            ),
                          ),
                          //
                          SizedBox(height: 5),
                          AppText.large(
                            'Emma Green',
                            maxLine: 1,
                            textOverflow: TextOverflow.ellipsis,
                            color: Color.fromARGB(255, 33, 33, 33),
                          ),
                          //SizedBox(height: 1),
                          AppText.small(
                            'Agent & Team Leader @ AGL Cocody Riviera LCC',
                          ),
                          SizedBox(height: 5),
                          AppText.small(
                            'numéro matricule - 123456789',
                            fontWeight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            //SizedBox(height: 10),
            Expanded(
              child: Container(
                color: Colors.white,
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.medium('Général'),
                      SizedBox(height: 15),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 0.8,
                            color: Palette.separatorColor,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        height: 80,
                        child: Column(
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: InfosColumn(
                                      label: 'Nom',
                                      widget: Expanded(
                                        child: AppText.medium('Emma'),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InfosColumn(
                                      label: 'Prénoms',
                                      widget: Expanded(
                                        child: AppText.medium('Green'),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 0.8,
                                      color: Palette.separatorColor,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 215, 214, 214),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                        ),
                                      ),
                                      child: Icon(
                                        CupertinoIcons.envelope_fill,
                                        color: Color.fromARGB(255, 57, 57, 57),
                                      ),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: AppText.medium(
                                          'contact-agent@agl.com'),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      ///////
                      ///
                      SizedBox(height: 15),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Palette.separatorColor,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 215, 214, 214),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5),
                                ),
                              ),
                              child: Icon(
                                CupertinoIcons.phone_fill,
                                color: Color.fromARGB(255, 65, 65, 65),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: AppText.medium('+225 07 7975 0404 039'),
                            )
                          ],
                        ),
                      ),
                      //////////
                      ///
                      SizedBox(height: 15),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Palette.separatorColor,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 2),
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 215, 214, 214),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(5),
                                  topLeft: Radius.circular(5),
                                ),
                              ),
                              child: Center(
                                child: AppText.medium(
                                  'ID',
                                  fontWeight: FontWeight.w800,
                                  fontSize: 19,
                                ),
                              ),
                            ),
                            SizedBox(width: 5),
                            Expanded(
                              child: AppText.medium('CI0004859400305403'),
                            )
                          ],
                        ),
                      ),
                      //////////
                      ///
                      SizedBox(height: 15),
                      Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                            color: Palette.separatorColor,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                                padding: const EdgeInsets.only(top: 2),
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 215, 214, 214),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(5),
                                    topLeft: Radius.circular(5),
                                  ),
                                ),
                                child: Icon(
                                  Icons.location_on,
                                  color: Color.fromARGB(255, 65, 65, 65),
                                )),
                            SizedBox(width: 5),
                            Expanded(
                              child: AppText.medium(
                                  'Abidjan - Cocody II plateaux'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(height: 100),
                      CustomButton(
                        color: Colors.red.withOpacity(0.03),
                        textColor: Colors.red,
                        width: double.infinity,
                        height: 35,
                        radius: 5,
                        text: 'Se décoordonner',
                        onPress: () {},
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        child: CopyRight(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _tagContainer({
    Color color = const Color.fromARGB(255, 6, 53, 101),
    IconData icon = CupertinoIcons.checkmark_circle_fill,
    bool withIcon = true,
    String text = '10+ expérience',
  }) =>
      Container(
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
      );
}
