import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/chart_list.dart';
import 'package:icanhelp/pages/invitations.dart';
import 'package:icanhelp/pages/princiapl.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();

  final int index;

  const HomePage({super.key, this.index = 0});
}

class _HomePageState extends State<HomePage> {

  late ApiService apiService;
  UserProfile? user;
  bool isLoadingUser = true;
  int _selectedIndex = 0;
  int index = 0;

  late final client;
  List<Widget> widgetOptions = [];

  @override
  void initState() {
    setState(() {
      _selectedIndex = widget.index;
    });
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    super.initState();
    _fetchMyProfil();

    widgetOptions = [
      PrincipalPage(),
      ChatListPage(),
      InvitationsPage(),
    ];
   
  }

  List<String?> interests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _selectedIndex == 0
              ? PreferredSize(
                preferredSize: Size.fromHeight(80),
                child: Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    title: Row(
                      children: [
                        isLoadingUser
                            ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                              ),
                            )
                            : Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: AppColors.primary,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(25),
                                ),
                              ),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  'images/image1.jpg',
                                ),
                              ),
                            ),
                        SizedBox(width: 8),
                        isLoadingUser
                            ? Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: 100,
                                height: 20,
                                color: Colors.white,
                              ),
                            )
                            : Text(
                              user != null ? user!.user.username! : '...',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                        Spacer(),
                        Icon(Icons.notification_add, color: Colors.black54),
                      ],
                    ),
                  ),
                ),
              )
              : null,
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 2),
        margin: EdgeInsets.fromLTRB(30, 0, 30, 30),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: Colors.grey,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: ""),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  _fetchMyProfil() async {
    try {
      user = await apiService.getMyProfil();
      final storage = FlutterSecureStorage();
      await storage.write(key: 'myProfile', value: json.encode(user));
      setState(() {
        isLoadingUser = false;
        interests =
            user!.skillsPersonal.map((skill) => skill.title).toList()
                as List<String?>;
      });
    } catch (e) {
      print("Erreur lors de la récupération du profil : $e");
    }
  }
}
