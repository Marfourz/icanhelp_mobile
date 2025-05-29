import 'package:flutter/material.dart';
import 'package:icanhelp/components/ILogo.dart';
import 'package:icanhelp/components/IMessageSnackbar.dart';
import 'package:icanhelp/components/StepIndicator.dart';
import 'package:icanhelp/models/Skill.dart';
import 'package:icanhelp/pages/auth/signup.dart';
import 'package:icanhelp/pages/auth/skills_personal.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:dio/dio.dart';

class SkillsDesiredScreen extends StatefulWidget {
  @override
  _SkillsDesiredScreenState createState() => _SkillsDesiredScreenState();
}

class _SkillsDesiredScreenState extends State<SkillsDesiredScreen> {

  final TextEditingController _searchController = TextEditingController();
  
  late ApiService apiService;
  List<Skill> addedSkills = [];
  List<Skill> selectedSkills = [];
  List<Skill> popularSkills = [];

  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    _fetchSkills();

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo
              Center(
                child: ILogo(),
              ) ,
              const SizedBox(height: 20),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    StepIndicator(
                      text: 'Informations personnelles',
                      isActive: false,
                      page: Signup()

                    ),
                    StepIndicator(text: 'Mes compétences', isActive: false, page : SkillsPersonalScreen()),
                    StepIndicator(
                      text: 'Compétences recherchées',
                      isActive: true,
                      page: SkillsDesiredScreen(),
                    ),
                  ],
                ),
              const SizedBox(height: 40),

              // Titre
              Text(
                "Compétences à apprendre",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 10),

              // Champ de recherche avec bouton "+"
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: "Rechercher une compétence...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _updateSkills,
                    style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: AppColors.primary,
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 15),
              
              Expanded(
                child: SingleChildScrollView(child:   Column(
                  
                  children: addedSkills.map((skill) {
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(skill.title!),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              addedSkills.remove(skill);
                              _deleteSkill(skill.id!);
                              
                            });
                          },
                        ),
                      ),
                    );
                  }).toList(),
                ),
            )
                
               ),

              

              // Boutons Passer & Suivant
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildButton("Retour", Colors.black, Colors.white, (){
                    Navigator.pop(context);
                  }),
                  _buildButton("Suivant", AppColors.primary, Colors.white, (){
                    Navigator.pushNamed(context, '/home');
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String text, Color bgColor, Color textColor, VoidCallback? onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: bgColor,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          color: textColor,
        ),
      ),
    );
  }

  Future<void> _fetchSkills() async {
    try {
      addedSkills = await apiService.getUserDesiredSkills();
      setState(() {});
    } catch (e) {
      print("Erreur lors de la récupération des compétences : $e");
    }
  }

  Future<void> _deleteSkill(int id) async {
    try {

      await apiService.removeDesiredSkill({'competence_ids': [id]});
        MessageSnackbar.show(
          context,
          message: "Compétence retirée !!" ,
          isSuccess: true,
          onTop: true
        );
      setState(() {});
    } catch (e) {
      print("Erreur lors de la supression de la compétence : $e");
    }
  }

  void _updateSkills() async {

    if(_searchController.text.isNotEmpty){
          List<String> selectedSkills = [_searchController.text];
    try {
     addedSkills = await apiService.addUserDesiredSkills(
        {"competences": selectedSkills},
      );
      MessageSnackbar.show(
          context,
          message: "Compétence ajoutée !!" ,
          isSuccess: true, 
          onTop: true
        );
      setState(() {
        _searchController.text = "";
      });
    } catch (e) {
     
        MessageSnackbar.show(
            context,
            message: e.toString() ,
            isSuccess: false,
          );
    }

    }
  }



}
