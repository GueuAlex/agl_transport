import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:scanner/bloc/piece_bloc/piece_bloc.dart';
import 'package:scanner/screens/add_delivering/deli_verify.sucess.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/internet_bloc/internet_bloc.dart';
import 'bloc/options_bloc/options_bloc.dart';
import 'config/functions.dart';
import 'dependency_injection.dart';
import 'screens/add_delivering/add_deli_screen.dart';
import 'screens/add_visite_screen/add_visite_screen.dart';
import 'screens/auth/login/login.dart';
import 'screens/auth/pin_code_screen.dart';
import 'screens/create_delivery/create_delivery_screen.dart';
import 'screens/create_delivery/delivery.sucess.dart';
import 'screens/delivering/deliverig_screen.dart';
import 'screens/home/home.dart';
import 'screens/in_process_delivery/in_process_delivery.dart';
import 'screens/on_boarding/on_boarding_screen.dart';
import 'screens/qr_code_details/qr_code_details_screen.dart';
import 'screens/scanner/scan_screen.dart';
import 'screens/search_by_date/deli_search_by_date_screen.dart';
import 'screens/search_by_date/search_by_date_screen.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/stats_creen/stats_screen.dart';
import 'screens/verify_by_code/verify_by_code_screen.dart';
/* 
@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) {
    switch (taskName) {
      case "task-identifier":
        print(
            '****************************************************************\n****************************************************************\n************************ first task done************************\n****************************************************************\n****************************************************************\n****************************************************************\n****************************************************************');
        break;
      default:
    }
    return Future.value(true);
  });
} */

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /* FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Log l'erreur et la pile24-804725
    debugPrint(details.exception.toString());
    debugPrint(details.stack.toString());
  }; */
  // Charger les variables d'environnement
  await dotenv.load(fileName: ".env");
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isVisiteModule = await prefs.getBool('isVisiteModule') ?? false;
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  /*  await Workmanager().initialize(
    callbackDispatcher,
    isInDebugMode: true,
  ); */
  if (isVisiteModule) {
    Timer.periodic(Duration(minutes: 2), (timer) {
      Functions.getVisites();
    });
  }

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<DeliveryBloc>(
          create: (context) => DeliveryBloc(),
        ),
        BlocProvider<InternetBloc>(
          create: (context) => InternetBloc(),
        ),
        BlocProvider(
          create: (context) => PieceBloc(),
        )
      ],
      child: const MyApp(),
    ),
  );
  DependencyInjection.init();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('fr'),
        Locale('en'),
      ],
      locale: const Locale('eu', 'FR'),
      title: 'Secure Scan',
      theme: ThemeData(
        useMaterial3: false,
        scaffoldBackgroundColor: Colors.white,
        primarySwatch: Colors.amber,
        fontFamily: "Gordita",
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      initialRoute: SplashScreen.routeName,
      //home: const SplashScreen(),
      //home: const Home(),
      //home: const ScanSreen(),
      //initialRoute: ,
      routes: {
        '/': (ctxt) => const Home(),
        SplashScreen.routeName: (ctxt) => const SplashScreen(),
        ScanScreen.routeName: (ctxt) => const ScanScreen(),
        LoginScreen.routeName: (ctxt) => const LoginScreen(),
        QrCodeDetailsScreen.routeName: (ctxt) => const QrCodeDetailsScreen(),
        VerifyByCodeSheet.routeName: (ctxt) => const VerifyByCodeSheet(),
        SearchByDateScreen.routeName: (ctxt) => const SearchByDateScreen(),
        DeliveringScreen.routeName: (ctxt) => const DeliveringScreen(),
        AddDeliScree.routeName: (ctxt) => const AddDeliScree(),
        DeliSearchByDateScreen.routeName: (ctxt) =>
            const DeliSearchByDateScreen(),
        PincodeScreen.routeName: (ctxt) => const PincodeScreen(),
        InProcessDelivery.routeName: (ctxt) => const InProcessDelivery(),
        StatsScreen.routeName: (ctxt) => const StatsScreen(),
        AddVisiteScreen.routeName: (ctxt) => const AddVisiteScreen(),
        CreateDeliveryScreen.routeName: (ctxt) => const CreateDeliveryScreen(),
        OnBoardingScreen.routeName: (ctxt) => const OnBoardingScreen(),
        DeliverySucess.routeName: (ctxt) => const DeliverySucess(),
        DeliveryVerifySucess.routeName: (ctxt) => const DeliveryVerifySucess(),
      },
      builder: EasyLoading.init(),
    );
  }
}
