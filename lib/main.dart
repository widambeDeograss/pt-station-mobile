import 'dart:io';
import 'dart:async';
import 'package:pts/notifier/pump_status_notifier.dart';

import 'globals.dart';
import 'package:sizer/sizer.dart';
import 'package:pts/pages/signin.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pts/manager/manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pts/notifier/connectivity_change_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => PumpStatusNotifier()),
      ChangeNotifierProvider(create: (context) => ConnectivityChangeNotifier())
    ],
    child: Sizer(builder: (context, orientation, deviceType) {
      return const MyApp();
    }),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // FlutterStatusbarcolor.setStatusBarColor(const Color(0xFFFF5733));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: primaryRed, useMaterial3: false),
      home: const SplashScreen(),
    );
  }
}

// Splash Screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late Timer timer;
  late SharedPreferences preferences;

  getSharedPreference() async {
    preferences = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    getSharedPreference();

    timer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (preferences.containsKey("session")) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ManagerDashboard(
                      pageIndex: 0,
                    )),
            (Route<dynamic> route) => false);
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Signin()));
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
          color: Colors.white,
          image:
              DecorationImage(image: AssetImage("assets/images/splash.png"))),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
