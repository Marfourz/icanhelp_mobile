import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/auth/signup.dart';
import 'package:icanhelp/pages/auth/skills_desired.dart';
import 'package:icanhelp/pages/auth/skills_personal.dart';
import 'package:icanhelp/pages/home.dart';
import 'package:icanhelp/pages/auth/login.dart';
import 'package:icanhelp/pages/onboarding/onboarding.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:dio/dio.dart';

void main() async {
   WidgetsFlutterBinding.ensureInitialized();
      
 // Vérifiez si l'utilisateur a déjà vu l'écran de onboarding
  final storage = FlutterSecureStorage();
  final firstTime = await storage.read(key: "first_time");
   if (firstTime == null) {
    await storage.write(key: "first_time", value: "false");
    runApp(MyApp(startRoute: '/onboarding'));
  } 

  else {
    // Vérifier si l'utilisateur est connecté en récupérant son profil
    bool isAuthenticated = await _checkIfAuthenticated();
    if (isAuthenticated) {
      runApp(MyApp(startRoute: '/home'));
    } else {
      runApp(MyApp(startRoute: '/login'));
    }
  }
}

Future<bool> _checkIfAuthenticated() async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: "access_token");

  if (token == null) {
    return false;
  }

  try {
    final dio = DioClient.getInstance();
    final apiService = ApiService(dio);
    UserProfile profile = await apiService.getMyProfil();
    await storage.write(key: "user_profile", value: profile.toString());
    return true;
  } catch (e) {
    print("Erreur lors de la récupération du profil: $e");
    return false;
  }
}

class MyApp extends StatelessWidget {
final String startRoute;

  MyApp({super.key, required this.startRoute});

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ICanHelp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primary,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      navigatorKey: navigatorKey,
      initialRoute: startRoute,
      routes: {
        '/onboarding': (context) => Onboarding(),
        '/login': (context) => Login(),
        '/home': (context) => HomePage(),
        '/signup': (context) => Signup(),
        '/skills_desired': (context) => SkillsDesiredScreen(),
        '/skills_personal': (context) => SkillsPersonalScreen(),
      },
    );
  }
}
