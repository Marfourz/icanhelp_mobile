import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icanhelp/components/IButton.dart';
import 'package:icanhelp/components/IMessageSnackbar.dart';
import 'package:icanhelp/components/Input.dart';
import 'package:icanhelp/models/login_request.dart';
import 'package:icanhelp/pages/auth/signup.dart';
import 'package:icanhelp/pages/auth/skills_personal.dart';
import 'package:icanhelp/pages/home.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:icanhelp/theme.dart';
import 'package:retrofit/dio.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late ApiService apiService;
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
  }

  void _login() async {
    if (_formKey.currentState!.validate()) {
      LoginRequest loginRequest = LoginRequest(
        username: _usernameController.text,
        password: _passwordController.text,
      );

      setState(() {
        loading = true;
      });
      try {
        HttpResponse response = await apiService.login(loginRequest);
        setState(() {
          loading = false;
        });
        final storage = FlutterSecureStorage();
        
        await storage.write(
          key: "access_token",
          value: response.data["access"],
        );
       Navigator.pushNamed(context, '/home');

        
      } catch (error) {
        setState(() {
          loading = false;
        });

        String errorMessage = "";

        final res = (error as DioException).response;

        errorMessage = "Un problème est survenu";
        if (res?.statusCode == 401) {
          errorMessage = "Mot de passe ou nom d'utilisateur invalide";
        }

        MessageSnackbar.show(
            context,
            message: errorMessage ,
            isSuccess: false, // ou false pour une erreur
          );
       
      }

     
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 30),

          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'assets/images/image_login.png',
                  width: 300.0,
                  height: 200,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                // Steps
                Row(
                  children: [
                    Text(
                      "Se connecter",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),

                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputField(
                        label: 'Nom d’utilisateur',
                        controller: _usernameController,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Champ obligatoire"
                                    : null,
                      ),
                      InputField(label: 'Mot de passe', isPassword: true, controller: _passwordController,),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: IButton(
                    loading: loading,
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    text: "Se connecter",
                  ),
                ),

                const SizedBox(height: 20),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous n'avez pas encore de compte? "),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text(
                        "Incrivez vous",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
