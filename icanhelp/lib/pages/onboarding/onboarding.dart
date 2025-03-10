import 'package:flutter/material.dart';
import 'package:icanhelp/theme.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  bool isLastPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/logo.png',
              width: 200.0,
              height: 79.09,
              fit: BoxFit.contain,
            ),
        
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    isLastPage = (index == 1); // Si on est sur la dernière page
                  });
                },
                children: [
                  buildPage(
                    image: 'images/onboarding1.png',
                    title: "Trouve et partage des compétences",
                    description:
                        "Recherchez les compétences qui vous intéressent ou proposez votre savoir-faire. ",
                  ),
                  buildPage(
                    image: 'images/onboarding2.png',
                    title: "Echanger gratuitement",
                    description: "Aucune barrière financière ! Échangez votre temps et vos connaissances pour apprendre et enseigner en toute simplicité.",
                  ),
                ],
              ),
            ),
        
            // Indicateur de pages + Boutons
            SmoothPageIndicator(
              controller: _controller,
              count: 2,
              effect: ExpandingDotsEffect(
                activeDotColor: AppColors.primary,
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
            const SizedBox(height: 20),
            isLastPage

                ? Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 10,
                  children: [
                    
                     SizedBox(
                      width: double.infinity,
                       child: ElevatedButton(
                        
                        onPressed: () {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                       
                        child: const Text("S'inscrire"),
                                           ),
                     ),

                     SizedBox(
                      width: double.infinity,
                       child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            '/home',
                          );
                        },
                         style: ElevatedButton.styleFrom(
                        
                          padding: EdgeInsets.symmetric(vertical: 16)
                        ),
                        child: const Text("Se connecter"),
                                           ),
                     ),
                  ],
                )
                : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed:
                          () => _controller.jumpToPage(2), // Passer l'onboarding
                      child: const Text("Passer"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInOut,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),

                      child: const Text("Suivant"),
                    ),
                  ],
                ),
          ],
        ),
      ),
    );
  }

  Widget buildPage({
    required String image,
    required String title,
    required String description,
  }) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(image, height: 200),
            const SizedBox(height: 20),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
