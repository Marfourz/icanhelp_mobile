import 'package:flutter/material.dart';
import 'package:icanhelp/components/IButton.dart';
import 'package:icanhelp/components/ILogo.dart';
import 'package:icanhelp/components/IMessageSnackbar.dart';
import 'package:icanhelp/components/Input.dart';
import 'package:icanhelp/components/StepIndicator.dart';
import 'package:email_validator/email_validator.dart';
import 'package:icanhelp/models/signup_request.dart';
import 'package:icanhelp/pages/auth/login.dart';
import 'package:icanhelp/pages/auth/skills_desired.dart'; 
import 'package:icanhelp/pages/auth/skills_personal.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:dio/dio.dart';
import 'package:icanhelp/theme.dart';
import 'package:retrofit/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Signup extends StatefulWidget {
  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool loading = false;

  String? passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Le mot de passe est requis';
    }
    if (value.length < 6) {
      return 'Le mot de passe doit contenir au moins 6 caractères';
    }
    return null;
  }

  String? confirmPasswordValidator(String? value) {
    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }
    return null;
  }

  late ApiService apiService;

  @override
  void initState() {
    super.initState();
    apiService = ApiService(Dio());
  }

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      SignupRequest signupRequest = SignupRequest(
        email: _emailController.text,
        username: _usernameController.text,
        password: _passwordController.text,
      );

      try {
        HttpResponse response = await apiService.signup(signupRequest);
        setState(() {
          loading = false;
        });
        final storage = FlutterSecureStorage();

        await storage.write(key: "access_token", value: response.data["access_token"]);
        Navigator.pushNamed(context, '/skills_personal');
      } catch (error) {
        setState(() {
          loading = false;
        });

        String errorMessage = "";

        final res = (error as DioException).response;

        errorMessage = res!.statusMessage ?? "Un problème est survenu";
        MessageSnackbar.showBackendErrors(context, res.data);
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
                ILogo(),
                const SizedBox(height: 20),
                // Steps
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepIndicator(
                      text: 'Informations personnelles',
                      isActive: true,
                      page : Signup()
                    ),
                    StepIndicator(text: 'Mes compétences', isActive: false, page : SkillsPersonalScreen()),
                    StepIndicator(
                      text: 'Compétences recherchées',
                      isActive: false,
                      page : SkillsDesiredScreen()
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Form fields
                Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      InputField(
                        label: 'Email',
                        validator:
                            (value) =>
                                EmailValidator.validate(value!)
                                    ? null
                                    : "Veillez entrer un mail valide",
                        controller: _emailController,
                      ),
                      InputField(
                        label: 'Nom d’utilisateur',
                        controller: _usernameController,
                        validator:
                            (value) =>
                                value == null || value.isEmpty
                                    ? "Champ obligatoire"
                                    : null,
                      ),
                      InputField(
                        label: 'Mot de passe',
                        isPassword: true,
                        validator: passwordValidator,
                        controller: _passwordController,
                      ),
                      InputField(
                        label: 'Confirmer le mot de passe',
                        isPassword: true,
                        validator: confirmPasswordValidator,
                        controller: _confirmPasswordController,
                      ),
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
                        _signup();
                      }
                    },
                    text: "S'inscrire",
                  ),
                ),

                const SizedBox(height: 20),

                // Already have an account
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Vous avez déjà un compte? "),
                    GestureDetector(
                      onTap: () {
                   Navigator.pushNamed(context, '/login');
                      },
                      child: const Text(
                        "Connectez-vous",
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
