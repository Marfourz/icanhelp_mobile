import 'package:flutter/material.dart';
import 'package:icanhelp/components/IButton.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/contact_user.dart';
import 'package:icanhelp/pages/invitations.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';

class ProfilDetails extends StatefulWidget {
  int id;

  ProfilDetails({super.key, required this.id});
  @override
  State<ProfilDetails> createState() => _ProfilDetailsState();
}

class _ProfilDetailsState extends State<ProfilDetails> {
  late ApiService apiService;
  UserProfile? user;
  String username = "";
  
  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text( 'Profil', style: const TextStyle(color: Colors.black)),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder(
        future: apiService.getUserProfil(widget.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          } else {
            user = snapshot.data;
            username = user!.user.username!;
           
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Avatar
                  Center(
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.deepPurple.shade100,
                      child: const Icon(
                        Icons.person,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Description
                  Center(
                    child: Text(
                      user!.user.username!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Text(
                    "Mes compétences",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        user!.skillsPersonal.map((interest) {
                          return Chip(
                            label: Text(interest.title!),
                            backgroundColor: Colors.orange[100],
                          );
                        }).toList(),
                  ),

                  const SizedBox(height: 30),
                 user!.skillsDesired.isNotEmpty ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       const Text(
                    "Je souhaite apprendre : ",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                   Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children:
                        user!.skillsDesired.map((interest) {
                          return Chip(
                            label: Text(interest.title!),
                            backgroundColor: Colors.orange[100],
                          );
                        }).toList(),
                  ) ,
                    ],
                  ) : Container(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                    
                       ElevatedButton(
                      onPressed: () {
                        Navigator.push(context,  MaterialPageRoute(
                                    builder: (context) => ContactUserPage(userProfile: user!)),
                                  );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),

                      child: const Text("Envoyer l'invitation"),
                    ),
                     ]
                 
                  )
                 
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
