import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icanhelp/components/IButton.dart';
import 'package:icanhelp/components/IMessageSnackbar.dart';
import 'package:icanhelp/models/Invitation.dart';
import 'package:icanhelp/models/SendInvitation.dart';
import 'package:icanhelp/models/Skill.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';

class ContactUserPage extends StatefulWidget {
  final UserProfile userProfile;

  ContactUserPage({required this.userProfile});

  @override
  _ContactUserPageState createState() => _ContactUserPageState();
}

class _ContactUserPageState extends State<ContactUserPage> {
  final Map<String, dynamic> user = {
    "name": "Marie Dubois",
    "profilePic": 'images/image2.jpg',
    "skills": ["Guitare", "Piano"],
  };

  late ApiService apiService;

  List<Skill> skillsToLearn = [];
  List<Skill> skillsToTeach = [];
  TextEditingController messageController = TextEditingController();
  late UserProfile myProfil;
  final storage =  FlutterSecureStorage();
  bool sending = false;

  @override
  void initState() {
    super.initState();

    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    messageController.text =
        "Bonjour ${widget.userProfile.user.username}, j'aimerais échanger avec toi pour apprendre : .";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
         backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          "Contacter",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<dynamic>(
          future: _getMyProfil(), 
          builder: (context, snapshot){
          
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
           
            else if (snapshot.hasError) {
              return Text('Erreur : ${snapshot.error}');
            }

            else{
              myProfil = snapshot.data!;
              return    Padding(
        padding: EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 5)],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage(user["profilePic"] as String),
                      radius: 30,
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.userProfile.user.username as String,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          "📍 ${user["distance"]}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Je veux apprendre :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children:
                    widget.userProfile.skillsPersonal.map<Widget>((skill) {
                      return ChoiceChip(
                        label: Text(skill.title!),
                        selected: skillsToLearn.contains(skill),
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? skillsToLearn.add(skill)
                                : skillsToLearn.remove(skill);
                            _updateMessage();
                          });
                        },
                      );
                    }).toList(),
              ),

              SizedBox(height: 20),
              Text(
                "Je peux enseigner :",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children:
                    myProfil.skillsPersonal.map<Widget>((skill) {
                      return ChoiceChip(
                        label: Text(skill.title!),
                        selected: skillsToTeach.contains(skill),
                        onSelected: (selected) {
                          setState(() {
                            selected
                                ? skillsToTeach.add(skill)
                                : skillsToTeach.remove(skill);
                          });
                        },
                      );
                    }).toList() ,
              ),

              SizedBox(height: 20),
              Text("Message d'invitation"),
              SizedBox(height: 8),
              TextField(
                maxLines: 4,
                controller: messageController,
                decoration: InputDecoration(
                  hintText: "Écrivez votre message ici...",
                  filled: true,
                  fillColor: Colors.grey[100],

                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 150,
                  child: IButton(
                    loading: sending,
                    onPressed: () {
                      _sent();
                    },
                    text: 'Envoyer',
                  ),
                ),
              ),
            ],
          ),
        ),
      );}
          }
    )
      
    );
  }

  _updateMessage() {
    messageController.text =
        "Bonjour ${widget.userProfile.user.username}, j'aimerais échanger avec toi pour apprendre ${skillsToLearn.map((skill) => skill.title).join(", ")}.";
  }

  _getMyProfil()async{
     myProfil = UserProfile.fromJson(json.decode((await storage.read(key: 'myProfile'))!)) ; 
     return myProfil;  
     }
  _sent() async {
    setState(() {
      sending = true;
    });

    try {
      final  invitationSent = await apiService.sendInvitation(
        SendInvitation(
          message: messageController.text,
          receiver: widget.userProfile.id,
          skillsDesired: skillsToLearn.map((skill) => skill.id!).toList(),
          skillsPersonal: skillsToTeach.map((skill) => skill.id!).toList(),
        ),
      );
      setState(() {
        sending = false;
      });
      MessageSnackbar.show(
        context,
        duration: Duration(seconds: 5),
        message: "Invitation envoyée à ${widget.userProfile.user.username}",
        isSuccess: true,
      );
      Navigator.pushNamed(context, '/home');
    } catch (e) {
      setState(() {
        sending = false;
      });
      print("Erreur lors de la récupération du profil : $e");
    }
  }
}
