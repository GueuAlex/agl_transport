import 'package:audioplayers/audioplayers.dart';
import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';
import '../../draggable_menu.dart';
import '../../widgets/action_button.dart';
import '../side_bar/custom_side_bar.dart';
import '../side_bar/open_side_dar.dart';
import 'widgets/scanner_container.dart';

class ScanScreen extends StatefulWidget {
  static String routeName = '/scannerScreen';
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool isScanCompleted = false;
  bool isFlashOn = false;
  bool isFontCamera = false;

  bool isTextFieldVisible = false;

  // In order to get hot reload to work we need to pause the camera if the platform
  // is android, or resume the camera if the platform is iOS.

  MobileScannerController mobileScannerController = MobileScannerController();
  bool showLabel1 = true;
  final TextEditingController codeController = TextEditingController();
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  //////////////////
  void closeScreen() {
    isScanCompleted = false;
  }

  ////////////////
  ///
  AudioCache player = AudioCache();

  @override
  void dispose() {
    mobileScannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: const CustomSiderBar(),
      appBar: AppBar(
        leading: const OpenSideBar(),
        iconTheme: const IconThemeData(
          color: Colors.black87,
        ),
        elevation: 0,
        title: AppText.medium('QR Scanner'),
      ),
      floatingActionButton: SpeedDial(
        openCloseDial: isDialOpen,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        backgroundColor: Palette.primaryColor,
        child: SvgPicture.asset(
          'assets/icons/menu.svg',
          height: 15,
          width: 15,
          colorFilter: ColorFilter.mode(
            Colors.white,
            BlendMode.srcIn,
          ),
        ),
        children: [
          SpeedDialChild(
              child: ActionButton(
                child: 'assets/icons/rotate_camera.svg',
                isOn: isFontCamera,
              ),
              //backgroundColor: Colors.red,
              label: 'Camera',
              labelStyle: TextStyle(color: Color.fromARGB(255, 55, 55, 55)),
              onTap: _switchCamera),
          SpeedDialChild(
            child: ActionButton(
              child: 'assets/icons/flash_on.svg',
              isOn: isFlashOn,
            ),
            //backgroundColor: Colors.red,
            label: 'Flash',
            labelStyle: TextStyle(color: Color.fromARGB(255, 55, 55, 55)),
            onTap: _toggleFlash,
          ),
        ],
      ),
      body: DoubleBackToCloseApp(
        snackBar: SnackBar(
          content: AppText.medium(
            'Double clic pour quitter',
            color: Colors.grey,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 25),
                  AppText.medium('Placez le code QR dans la zone'),
                  AppText.small('La numérisation démarre automatiquement')
                ],
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 2 - 500 / 2,
                left: MediaQuery.of(context).size.width / 2 - 250 / 2,

                //bottom: 0,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return Container(
                      height: 230,
                      width: 250,
                      color: Colors.amber,
                      child: ScannerContainer(
                        mobileScannerController: mobileScannerController,
                      ),
                    );
                  },
                ),
              ),
              DraggableMenu(),
            ],
          ),
        ),
      ),
    );
  }

  ///////////////////////

  ///
  ///////////////////////
  ///
  void _toggleFlash() {
    setState(() {
      isFlashOn = !isFlashOn;
    });
    mobileScannerController.toggleTorch();
  }

  void _switchCamera() {
    setState(() {
      isFontCamera = !isFontCamera;
    });
    mobileScannerController.switchCamera();
  }
}
