import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:scanner/config/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../widgets/custom_button.dart';
import '../../home/home.dart';
import '../../scanner/widgets/infos_column.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/loginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showLabel1 = true;
  final TextEditingController loginController = TextEditingController();

  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    /////////////::
    ///
    final Widget loginTextField = TextField(
      controller: loginController,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      onTap: () {
        setState(() {
          showLabel1 = false;
        });
      },
      cursorColor: Colors.black,
      decoration: InputDecoration(
        label: showLabel1
            ? AppText.medium('Entrez votre n° matricule')
            : Container(),
        border: InputBorder.none,
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.grey.withOpacity(0.2),
        title: AppText.medium('Authentification'),
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content:
              AppText.medium('Double clic pour quitter', color: Colors.grey),
        ),
        child: Container(
          height: size.height,
          width: double.infinity,
          color: Colors.white,
          child: SafeArea(
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.grey.withOpacity(0.2),
                  width: double.infinity,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(30),
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Center(
                          child: Icon(Icons.vpn_key),
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      AppText.large('Bonjour'),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: AppText.small(
                            'Veuillez renseigner votre numéro matricule',
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  margin: EdgeInsets.only(top: size.height * 0.21),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 70,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 25.0,
                                left: 25.0,
                                bottom: 15,
                              ),
                              child: InfosColumn(
                                opacity: 0.1,
                                label: 'N° matricule',
                                widget: Expanded(
                                  child: loginTextField,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: Row(
                                children: [
                                  Checkbox(
                                    checkColor: Colors.white,
                                    focusColor: Palette.primaryColor,
                                    // activeColor: Palette.primaryColor,
                                    side: BorderSide(
                                      width: 1.5,
                                      color: Palette.primaryColor,
                                    ),

                                    fillColor: WidgetStatePropertyAll(
                                      Palette.primaryColor,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    value: isChecked,
                                    onChanged: (value) {
                                      setState(() {
                                        isChecked = value!;
                                      });
                                    },
                                  ),
                                  SizedBox(width: 5),
                                  AppText.medium('Se souvenir de moi'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 25.0,
                                left: 25.0,
                              ),
                              child: CustomButton(
                                color: Palette.primaryColor,
                                width: double.infinity,
                                height: 40,
                                radius: 5,
                                text: 'Connexion',
                                onPress: () async {
                                  //Functions.showLoadingSheet(ctxt: context);
                                  EasyLoading.showProgress(
                                    0.3,
                                    status: 'chargement...',
                                  );

                                  if (loginController.text.trim().isEmpty) {
                                    Functions.showToast(
                                        msg:
                                            'Veuillez renseigner votre numéro matricule',
                                        gravity: ToastGravity.TOP);
                                    EasyLoading.dismiss();
                                    return;
                                  } else {
                                    // fetching data from api
                                    // response === ok
                                    if (loginController.text == 'bonjour') {
                                      final SharedPreferences prefs =
                                          await SharedPreferences.getInstance();

                                      if (isChecked) {
                                        await prefs.setBool('isRemember', true);
                                      }
                                      Future.delayed(const Duration(seconds: 3))
                                          .whenComplete(() {
                                        EasyLoading.dismiss();
                                        Get.offAllNamed(Home.routeName);
                                      });
                                    } else {
                                      EasyLoading.dismiss();
                                      //Get.back();
                                      Functions.showToast(
                                        msg: 'Matricule invalide',
                                        gravity: ToastGravity.TOP,
                                      );
                                    }
                                  }
                                },
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
