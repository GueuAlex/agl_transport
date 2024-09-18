import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../config/app_text.dart';
import '../../../config/functions.dart';
import '../../../config/palette.dart';
import '../../../local_service/local_service.dart';
import '../../../model/agent_model.dart';
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

  bool isChecked = true;
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
        // title: AppText.medium('Authentification'),
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
                      AppText.medium('Authentification'),
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
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(30),
                            bottomRight: Radius.circular(30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
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
                                    await validateMatricule(
                                      context,
                                      loginController.text,
                                      isChecked,
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
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

Future<void> validateMatricule(
    BuildContext context, String matricule, bool isChecked) async {
  if (matricule.trim().isEmpty) {
    Functions.showToast(
        msg: 'Veuillez renseigner votre numéro matricule',
        gravity: ToastGravity.TOP);
    return;
  }
  EasyLoading.showProgress(
    0.3,
    status: 'chargement...',
  );
  final baseUrl = dotenv.env['BASE_URL']!;
  final response = await http.get(
    Uri.parse('${baseUrl}users/$matricule'),
  );
  /* print(response.statusCode);
  print(response.body); */

  if (response.statusCode == 200 || response.statusCode == 201) {
    var json = response.body;
    AgentModel agent = agentModelFromJson(json);
    // check if account is active
    if (!agent.actif) {
      EasyLoading.dismiss();
      Functions.showToast(
        msg: 'Votre compte est inactif veuillez contacter votre responsable',
        gravity: ToastGravity.TOP,
      );
      return;
    }

    int result = await LocalService().createLocalAgent(agent: agent);
    //print(result);

    if (result != 0) {
      // if user set remember me to true
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (isChecked) {
        await prefs.setBool('isRemember', true);
      }
      EasyLoading.dismiss();
      Get.offAllNamed(Home.routeName);
    } else {
      EasyLoading.dismiss();
      Functions.showToast(
        msg: 'Veuillez réessayer !',
        gravity: ToastGravity.TOP,
      );
    }
  } else {
    EasyLoading.dismiss();
    // Handle the error
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Matricule invalide')),
    );
  }
}
