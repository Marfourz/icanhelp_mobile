import 'package:flutter/material.dart';
import 'package:icanhelp/helper.dart';
import 'package:icanhelp/models/Discussion.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/messagerie.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ChatListPage(),
    );
  }
}

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chats = [
    {
      "name": "Athalia Putri",
      "message": "Good morning, did you sleep well?",
      "time": "Today",
      "avatar": "https://via.placeholder.com/150",
      "online": true,
      "unread": 1
    },
    {
      "name": "Raki Devon",
      "message": "How is it going?",
      "time": "Hier",
      "avatar": "",
      "online": false,
      "unread": 0
    },
    {
      "name": "Erlan Sadewa",
      "message": "Aight, noted",
      "time": "17h30",
      "avatar": "https://via.placeholder.com/150",
      "online": false,
      "unread": 1
    },
     {
      "name": "Raki Devon",
      "message": "How is it going?",
      "time": "Hier",
      "avatar": "",
      "online": false,
      "unread": 0
    },
    {
      "name": "Erlan Sadewa",
      "message": "Aight, noted",
      "time": "17h30",
      "avatar": "https://via.placeholder.com/150",
      "online": false,
      "unread": 1
    },
    {
      "name": "Athalia Putri",
      "message": "Good morning, did you sleep well?",
      "time": "Today",
      "avatar": "https://via.placeholder.com/150",
      "online": true,
      "unread": 1
    },
    {
      "name": "Raki Devon",
      "message": "How is it going?",
      "time": "Hier",
      "avatar": "",
      "online": false,
      "unread": 0
    },
  ];

  late List<Discussion> discussions;
  String searchQuery = "";
  late ApiService apiService ;
  late UserProfile myProfil;

  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    loadMyProfil().then((profil)=>{
      setState(() {
        myProfil = profil;
      })
    });
    setState(() {});

  }


  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredChats = chats
        .where((chat) => chat["name"]!.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Chats"), automaticallyImplyLeading: false),
      body: FutureBuilder(future: apiService.getDiscussions(), builder: (context, snapshot){
         if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator(color: AppColors.primary,),);
            }
           
            else if (snapshot.hasError) {
         
              return Text('Erreur : ${snapshot.error}');
            }
            else{
              discussions = snapshot.data!.results;
              return  Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all( 12),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value;
                  });
                },
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search...",
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 14),
                itemCount: discussions.length,
                itemBuilder: (context, index) {
                  var chat = discussions[index];
                  return  ListTile(
                    onTap: (){
                            Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Messagerie(discussionId: chat.id,),
                                        ),
                                      );
                    },
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          child: Text(chat.createdBy.user.username![0]),
                        ),
                        if (index % 2 == 0)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              backgroundColor: Colors.green,
                              radius: 5,
                            ),
                          ),
                      ],
                    ),
                    title: Text(chat.users.firstWhere((user)=>user.id != myProfil.id).user.username!, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(chat.lastMessage != null ? chat.lastMessage!['content'].toString() : 'Aucun message echangé'),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(formatDateTime(chat.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey)),
                        if (index % 3 == 0)
                          CircleAvatar(
                            backgroundColor: AppColors.primary,
                            radius: 10,
                            child: Text(chat.unreadMessagesCount.toString(),
                                style: TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
            }
      })
      
       );
  }


  String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(dateTime);

  if (difference.inDays > 0) {
    return DateFormat('dd MMM').format(dateTime); // Ex: "25 Mar"
  } else {
    return DateFormat('HH:mm').format(dateTime); // Ex: "14:30"
  }
}



}
