import 'package:flutter/material.dart';
import 'package:scanner/config/app_text.dart';
import 'package:scanner/config/palette.dart';
import 'package:scanner/screens/scanner/scan_screen.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/sucess_icon.dart';

class DeliveryVerifySucess extends StatefulWidget {
  static String routeName = 'DeliveryVerifySucess';
  const DeliveryVerifySucess({super.key});

  @override
  _DeliveryVerifySucessState createState() => _DeliveryVerifySucessState();
}

class _DeliveryVerifySucessState extends State<DeliveryVerifySucess>
    with TickerProviderStateMixin {
  bool _visible = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final _motif = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: size.height,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: AnimatedSlide(
                  offset: _visible
                      ? Offset(0, 0)
                      : Offset(0, 1), // Animation from bottom
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      buildIcon(),
                      AppText.large(
                        'C\'est un succès !',
                        fontWeight: FontWeight.w400,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: AppText.small(
                          fontSize: 13,
                          textAlign: TextAlign.center,
                          'La ${_motif.toLowerCase()} a bien été enregistrée, vous pouvez laisser passer le véhicule',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AnimatedSlide(
                offset: _visible
                    ? Offset(0, 0)
                    : Offset(0, 1), // Animation from bottom
                duration: const Duration(milliseconds: 500),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CustomButton(
                    color: Palette.primaryColor,
                    textColor: Colors.white,
                    width: double.infinity,
                    height: 35,
                    radius: 5,
                    text: 'Retour',
                    onPress: () {
                      _onBackPressed(context);
                    },
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }

  void _onBackPressed(BuildContext context) {
    setState(() {
      _visible = false; // Trigger animation to disappear
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      Navigator.pushReplacementNamed(
        context,
        ScanScreen.routeName,
      ); // After the animation ends, pop the page
    });
  }
}
