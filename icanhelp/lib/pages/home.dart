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

    widgetOptions = [PrincipalPage(), ChatListPage(), InvitationsPage()];
  }

  List<String?> interests = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
          _selectedIndex == 0
              ? AppBar(
                toolbarHeight: 100,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                titleSpacing: 10,
                leadingWidth: 100,

                actions: <Widget>[
                  //IconButton
                  IconButton(
                    icon: const Icon(Icons.notification_add),
                    tooltip: 'Comment Icon',
                    onPressed: () {},
                  ),

                  //IconButton
                  IconButton(
                    icon: const Icon(Icons.settings),
                    tooltip: 'Setting Icon',
                    onPressed: () {},
                  ),
                ],

                leading:
                    isLoadingUser
                        ? Shimmer.fromColors(
                          baseColor: Colors.grey[300]!,
                          highlightColor: Colors.grey[100]!,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                          ),
                        )
                        : Padding(
                          padding: const EdgeInsets.all(16),
                          child: CircleAvatar(
                            radius: 60,
                            backgroundImage: AssetImage('assets/images/image2.jpg'),
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                titleTextStyle: TextStyle(fontSize: 30),
                title:
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
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
              )
              : null,
      body: widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(32)),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),
        padding: EdgeInsets.symmetric(vertical: 12),
        margin: EdgeInsets.fromLTRB(30, 0, 30, 50),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildNavIcon(icon:Icons.home, index:0),
            _buildNavIcon(icon:Icons.chat, index:1),
            _buildNavIcon(icon:Icons.person, index:2 ),
          ],
        )
      ),
    );
  }

  Widget _buildNavIcon({required IconData icon, required int index}) {
    final isSelected = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          size: 30,
          color: isSelected ? Colors.white : Colors.black45,
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
