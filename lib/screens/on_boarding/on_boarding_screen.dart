import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../config/app_text.dart';
import '../../config/functions.dart';
import '../../config/palette.dart';
import '../../local_service/local_service.dart';
import '../../model/site_model.dart';
import '../../remote_service/remote_service.dart';
import '../../widgets/custom_button.dart';
import '../auth/login/login.dart';
import '../scanner/widgets/infos_column.dart';

class OnBoardingScreen extends StatefulWidget {
  static String routeName = 'on_boarding_screen';
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController controller = PageController();
  SiteModel? _selectedSite;

  String? deviceUid;
  String? deviceModel;
  String? deviceManufacturer;
  String? deviceOs;
  String? deviceOsVersion;

  @override
  void initState() {
    super.initState();
    EasyLoading.show();
    _initDeviceInfo().whenComplete(() => EasyLoading.dismiss());
  }

  Future<void> _initDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        setState(() {
          deviceUid = androidInfo.serialNumber; // Unique ID for Android
          deviceModel = androidInfo.model;
          deviceManufacturer = androidInfo.manufacturer;
          deviceOs = "Android";
          deviceOsVersion = androidInfo.version.release;
        });
      } else if (Platform.isIOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        setState(() {
          deviceUid = iosInfo.identifierForVendor; // Unique ID for iOS
          deviceModel = iosInfo.utsname.machine;
          deviceManufacturer = "Apple";
          deviceOs = "iOS";
          deviceOsVersion = iosInfo.systemVersion;
        });
      }
    } catch (e) {
      // Handle error
      print("Failed to get device info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Palette.primaryColor.withOpacity(0.8),
              Palette.primaryColor.withOpacity(0.1),
            ],
            begin: Alignment.bottomCenter,
          ),
        ),
        child: PageView(
          controller: controller,
          children: [
            Intro(
              onNext: () {
                controller.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut);
              },
            ),
            _setupDeviceForm(size: size)
          ],
        ),
      ),
    );
  }

  Container _setupDeviceForm({required Size size}) => Container(
        width: double.infinity,
        height: size.height,
        color: Colors.white,
        child: SafeArea(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                width: double.infinity,
                alignment: Alignment.center,
                child: AppText.medium('SETUP THIS DEVICE'),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 229, 229, 229)
                          .withOpacity(0.5), // Couleur de l'ombre avec opacité
                      blurRadius: 3, // Flou de l'ombre
                      spreadRadius: 0, // Étalement de l'ombre
                      offset: const Offset(0, 5), // Déplace l'ombre vers le bas
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText.large('Mise en route du téléphone'),
                        AppText.small(
                          'Nous collectons des informations essentielles sur votre appareil '
                          'pour assurer une gestion optimale des activités. Les données recueillies '
                          'incluent l\'identifiant unique, le modèle, le fabricant, et la version du système d\'exploitation. '
                          'Ces informations nous aident à améliorer nos services et à garantir un suivi précis.',
                        ),
                        const SizedBox(height: 20),
                        _cardContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.medium('Informations du téléphone'),
                              Row(
                                children: [
                                  Expanded(
                                    child: InfosColumn(
                                      label: 'Model',
                                      widget: Expanded(
                                        child:
                                            AppText.medium(deviceModel ?? ''),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InfosColumn(
                                      label: 'Manufacturer',
                                      widget: Expanded(
                                        child: AppText.medium(
                                            deviceManufacturer ?? ''),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              InfosColumn(
                                label: 'Factory',
                                widget: Expanded(
                                  child: AppText.medium(deviceUid ?? ''),
                                ),
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: InfosColumn(
                                      label: 'System',
                                      widget: Expanded(
                                        child: AppText.medium(deviceOs ?? ''),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: InfosColumn(
                                      label: 'OS version',
                                      widget: Expanded(
                                        child: AppText.medium(
                                            deviceOsVersion ?? ''),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        _cardContainer(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText.medium('Assigner a une localisation'),
                              AppText.small(
                                'Veuillez selectionner la localisation pour laquelle ce terminal est destiné',
                              ),
                              InfosColumn(
                                label: 'Localisation',
                                opacity: 0.12,
                                widget: Expanded(
                                  child: InkWell(
                                    onTap: () => Functions.showBottomSheet(
                                      ctxt: context,
                                      widget: _siteSelectorWidget(size: size),
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: AppText.medium(
                                            _selectedSite != null
                                                ? _selectedSite!.libelle
                                                : 'Selectionner une localisation',
                                          ),
                                        ),
                                        Icon(
                                          Icons.arrow_drop_down,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 35,
                        ),
                        CustomButton(
                          color: Palette.primaryColor,
                          width: double.infinity,
                          height: 35,
                          radius: 5,
                          text: 'Continuer',
                          onPress: () => _handleDeviceRegistration(),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );

  void _handleDeviceRegistration() async {
    if (_selectedSite == null) {
      Functions.showToast(
        msg: 'Veuillez selectionner une localisation',
        gravity: ToastGravity.TOP,
      );
      return;
    }
    EasyLoading.show();
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    Map<String, dynamic> deviceData = {};

    try {
      if (Theme.of(context).platform == TargetPlatform.android) {
        AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
        deviceData = {
          "id": 1,
          "localisation_id": _selectedSite!.id,
          "site_id": _selectedSite!.id,
          "uid": androidInfo.id, // Identifiant unique
          "model": androidInfo.model,
          "manufacturer": androidInfo.manufacturer,
          "os": "Android",
          "os_version": androidInfo.version.release,
        };
      } else if (Theme.of(context).platform == TargetPlatform.iOS) {
        IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
        deviceData = {
          "id":
              1, // Utilisez un ID approprié ou laissez-le vide si auto-incrémenté
          "localisation_id": _selectedSite!.id,
          "site_id": _selectedSite!.siteId,
          "uid": iosInfo.identifierForVendor ?? 'unknown', // Identifiant unique
          "model": iosInfo.utsname.machine,
          "manufacturer": "Apple",
          "os": "iOS",
          "os_version": iosInfo.systemVersion,
        };
      }

      //print(deviceData);
      //return;

      // Enregistre le device en local
      LocalService localService = LocalService();
      await localService.createDevice(deviceData).then((result) {
        if (result == 0) {
          Functions.showToast(
            msg: 'Une erreur est survenue',
            gravity: ToastGravity.TOP,
          );

          EasyLoading.dismiss();
        } else {
          Functions.showToast(
            msg: 'Terminal enregistré avec succès',
            gravity: ToastGravity.TOP,
          );
          // post device data to API,  then go to login screen
          RemoteService().postData(endpoint: 'devices', postData: deviceData);

          EasyLoading.dismiss();
          Navigator.pushNamedAndRemoveUntil(
            context,
            LoginScreen.routeName,
            (route) => false,
          );
        }
      });
      // print('Device registered successfully!');
    } catch (e) {
      EasyLoading.dismiss();
      print('Failed to register device: $e');
    }
  }

  Container _siteSelectorWidget({required Size size}) => Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6.5),
        ),
        constraints: BoxConstraints(maxHeight: size.height * 0.4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 10,
              ),
              child: Row(children: [
                Expanded(child: Container()),
                Container(
                  width: 35,
                  height: 35,
                  decoration: BoxDecoration(
                    color: Palette.separatorColor,
                    shape: BoxShape.circle,
                  ),
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    child: Center(
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 16,
                      ),
                    ),
                  ),
                )
              ]),
            ),
            // creer un future builder pour les sites
            Expanded(
              child: FutureBuilder<List<SiteModel>>(
                future: RemoteService().getSites(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                        child: AppText.medium('Aucun site pour le moment'),
                      );
                    } else {
                      return ListView.builder(
                        //shrinkWrap: true,

                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          SiteModel site = snapshot.data![index];
                          return InkWell(
                            onTap: () {
                              setState(() {
                                _selectedSite = site;
                              });
                              Navigator.pop(context);
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(6.5),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: AppText.medium(
                                      site.libelle,
                                      color: Colors.black,
                                    ),
                                  ),
                                  Icon(
                                    CupertinoIcons.check_mark,
                                    color: Palette.primaryColor,
                                    size: 16,
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  } else {
                    if (snapshot.hasError) {
                      return Center(
                        child: AppText.medium('No sites found'),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator.adaptive(),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      );

  Widget _cardContainer({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 211, 211, 211),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 1),
          )
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: child,
    );
  }
}

class Intro extends StatelessWidget {
  const Intro({
    super.key,
    required this.onNext,
  });
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        SizedBox(
            height: kToolbarHeight,
            width: size.width,
            child: Image.asset('assets/images/hub11.jpg', fit: BoxFit.cover)),
        MasonryGridView.builder(
          itemCount: 11,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(1.0),
              child: ClipRRect(
                child: Image.asset('assets/images/hub${index + 1}.jpg'),
                borderRadius: BorderRadius.circular(0),
              ),
            );
          },
        ),
        Container(
          width: size.width,
          height: size.height,
          color: Palette.primaryColor.withOpacity(0.35),
          child: Column(
            children: [
              Expanded(child: Container()),
              Container(
                width: size.width,
                // height: size.height * 0.3,
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Palette.primaryColor, // Couleur pleine en bas
                      Palette.primaryColor.withOpacity(0.95),
                      Palette.primaryColor.withOpacity(0.8),
                      Palette.primaryColor.withOpacity(0.6),
                      Palette.primaryColor
                          .withOpacity(0.05), // Transparent en haut
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    topRight: Radius.circular(5),
                  ),
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText.large(
                        'Optimisez votre Logistique',
                        color: Colors.white,
                      ),
                      AppText.small(
                        "Découvrez une nouvelle ère de gestion logistique grâce à notre application intuitive. Suivez les livraisons, gérez les visites, et améliorez l'efficacité opérationnelle en toute simplicité.",
                        color: Colors.white,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(2),
                            ),
                            child: InkWell(
                              onTap: onNext,
                              child: Row(
                                children: [
                                  AppText.medium(
                                    'SETUP DEVICE',
                                    fontSize: 12,
                                    color: Palette.primaryColor,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  Icon(
                                    Icons.chevron_right,
                                    color: Palette.primaryColor,
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(child: Container()),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
