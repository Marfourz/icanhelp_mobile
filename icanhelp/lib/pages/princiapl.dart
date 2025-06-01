import 'dart:async';

import 'package:flutter/material.dart';
import 'package:icanhelp/models/Skill.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/contact_user.dart';
import 'package:icanhelp/pages/profil_details.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:shimmer/shimmer.dart';

class PrincipalPage extends StatefulWidget {
  @override
  _PrincipalPageState createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  late ApiService apiService;
  UserProfile? user;
  List<UserProfile> users = [];
  bool isLoadingUser = true;
  bool isLoadingUsers = true;

  Timer? _debounce;

  

  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();

    apiService = ApiService(dio);
    _fetchUsers();
    _fetchMyProfil();
  }

  List<String?> interests = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Que veux-tu faire aujourd'hui ?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 15),

            TextField(
              onChanged: _onSearchChanged,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Ex: Guitare, Data Science, Peinture...",
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            SizedBox(height: 15),

              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: interests.map((interest) {
                  return Chip(
                    label: Text(interest!),
                    backgroundColor: Colors.white,
                  );
                }).toList(),
            ),
            
            SizedBox(height: 20),

           // Text(
             // "Personnes recommandées pour toi",
              //style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            //),
            SizedBox(height: 10),

            Expanded(
              child: isLoadingUsers
                  ? _buildShimmerList()
                  : ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        return Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(bottom: 12),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child:
                              GestureDetector(
                                onTap: ()=>{
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfilDetails(id: user.id),
                                      ),
                                )
                                },
                                child:  Row(
                                children: [
                                  CircleAvatar(
                                    backgroundImage: AssetImage("assets/images/image1.jpg"),
                                    radius: 30,
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          user.user.username!,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                        Text(
                                          getFormattedSkills(user.skillsPersonal),
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                      ],
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                       Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ContactUserPage(userProfile: user),
                                            ),
                                          );
                                    },
                                    style: TextButton.styleFrom(
                                      foregroundColor: AppColors.primary,
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                    ),
                                    child: Text("Contacter"),
                                  ),
                                ],
                              ),

                              )
                               ),
                            Divider(height: 1,color: Colors.black12,)
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      );
      
  }

 
 
 
 
 
 
 
 
 
 
 
 
 

 
  Widget _buildShimmerList() {
    return ListView.builder(
      itemCount: 5, // Nombre de skeleton loaders
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Container(
            margin: EdgeInsets.only(bottom: 12),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 16,
                        width: 120,
                        color: Colors.white,
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 12,
                        width: 80,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 24,
                  width: 80,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _fetchUsers() async {
    try {
      users = (await apiService.getUsersProfil()).results;
      setState(() {
        isLoadingUsers = false;
      });
    } catch (e) {
      print("Erreur lors de la récupération des compétences : $e");
    }
  }

  _fetchMyProfil() async {
    try {
      user = await apiService.getMyProfil();
      interests = user!.skillsPersonal.map((skill) => skill.title).toList() as List<String?>;
      setState(() {
        isLoadingUser = false;
      });
    } catch (e) {
      print("Erreur lors de la récupération du profil : $e");
    }
  }

  String getFormattedSkills(List<Skill> skills, {int maxSkills = 3}) {
    if (skills.isEmpty) return "Aucune compétence";

    List<String?> skillNames = skills.map((skill) => skill.title).toList();
    if (skillNames.length > maxSkills) {
      return "${skillNames.sublist(0, maxSkills).join(", ")}...";
    }
    return skillNames.join(", ");
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 1000), () async{
      print('Recherche déclenchée pour : $query');
      try{
        setState(() {
          isLoadingUsers = true;
        });

          users = (await apiService.searchUsersProfil(query));
        setState(() {
          isLoadingUsers = false;
        });
          print("salut");
      }
      catch(error){
        setState(() {
          isLoadingUsers = false;
        });
          print(error);
      }

    });
  }


}
