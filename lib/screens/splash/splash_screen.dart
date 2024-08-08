import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/palette.dart';
import '../../local_service/local_service.dart';
import '../auth/login/login.dart';
import '../on_boarding/on_boarding_screen.dart';
import '../scanner/scan_screen.dart';

class SplashScreen extends StatefulWidget {
  static String routeName = '/splashScreen';
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  /////////////::
  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
    if (_connectionStatus == ConnectivityResult.none) {
      setState(() {
        IsConnec = false;
      });
    } else {
      setState(() {
        IsConnec = true;
      });
    }
  }

  //////////////:////
  ///
  bool IsConnec = true;
  @override
  void initState() {
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    /*  Functions.getQrcodesFromApi();
    Functions.getScanHistoriesFromApi();
    Functions.allEntrepise();
    Functions.allLivrason(); */

    Future.delayed(const Duration(seconds: 10)).then((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      LocalService localService = LocalService();
      var deviceData = await localService.getDevice();
      //print(deviceData);
      if (deviceData == null) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          OnBoardingScreen.routeName,
          (route) => false,
        );
      } else {
        bool? isFirstTime = await prefs.getBool('isRemember');
        if (isFirstTime != null && isFirstTime) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            ScanScreen.routeName,
            (route) => false,
          );
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            LoginScreen.routeName,
            (route) => false,
          );
        }
      }
    });

    super.initState();
  }

  /////////////////:

  /////////////////::

  @override
  Widget build(BuildContext context) {
    /*   Future.delayed(const Duration(seconds: 10)).then((_) {
      if (IsConnec) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          ScanSreen.routeName,
          (route) => false,
        );
      }
    }); */
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 1),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(50),
                    width: 250,
                    height: 200,
                    child: Image.asset('assets/images/agl-logo-max.webp'),
                  ),
                  Container(
                    width: 100,
                    height: 50,
                    padding: const EdgeInsets.all(5),
                    child: LoadingAnimationWidget.newtonCradle(
                      color: Palette.primaryColor,
                      size: 70,
                    ),
                  )
                ],
              ),
              //const CopyRight()
            ],
          ),
        ),
      ),
    );
  }
}
