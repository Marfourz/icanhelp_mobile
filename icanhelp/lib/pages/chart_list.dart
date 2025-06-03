import 'package:flutter/material.dart';
import 'package:icanhelp/helper.dart';
import 'package:icanhelp/models/Discussion.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/messagerie.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:intl/intl.dart';

import '../components/EmptyState.dart';
import '../socket_helper.dart' as socketHelper;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: ChatListPage());
  }
}

class ChatListPage extends StatefulWidget {
  @override
  _ChatListPageState createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> {
  List<Map<String, dynamic>> chats = [];

  late List<Discussion> discussions;
  String searchQuery = "";
  late ApiService apiService;
  late UserProfile myProfil;

  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    loadMyProfil().then(
          (profil) =>
      {
        setState(() {
          myProfil = profil;
        }),
      },
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text("Chats"), automaticallyImplyLeading: false),
      body: FutureBuilder(
        future: apiService.getDiscussions(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          } else if (snapshot.hasError) {
            return Text('Erreur : ${snapshot.error}');
          } else {
            discussions = snapshot.data!.results;
            return discussions.isNotEmpty ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: "Search...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      itemCount: discussions.length,
                      itemBuilder: (context, index) {
                        var chat = discussions[index];
                        socketHelper.connectToWebSocket(
                            chat.id,
                            'chat_message',
                            _onNewMessageReceived
                        );
                        return ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                    Messagerie(discussionId: chat.id),
                              ),
                            );
                          },
                          leading: Stack(
                            children: [
                              CircleAvatar(
                                child: Text(
                                        chat.users.firstWhere((user) => user.id != myProfil.id)
                                      .user
                                      .username![0]),
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
                          title: Text(
                            chat.users
                                .firstWhere((user) => user.id != myProfil.id)
                                .user
                                .username!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            chat.lastMessage != null
                                ? chat.lastMessage!['content'].toString()
                                : 'Aucun message echangé',
                          ),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                formatDateTime(chat.updatedAt),
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              if (chat.nbMessagesNotRead > 0)
                                CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  radius: 10,
                                  child: Text(
                                    chat.nbMessagesNotRead.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ) : EmptyState(title: "Aucune discussion",
                description: "Une fois vos invitations acceptées, vous pourriez entamer la discussion");
          }
        },
      ),
    );
  }

  String formatDateTime(DateTime dateTime) {
    final localDateTime = dateTime.toLocal();
    final now = DateTime.now();

    final difference = now.difference(localDateTime);

    if (difference.inDays > 0) {
      return DateFormat('dd MMM').format(localDateTime); // Ex: "25 Mar"
    } else {
      return DateFormat('HH:mm').format(localDateTime); // Ex: "14:30"
    }
  }

  void _onNewMessageReceived(data){
    int index = discussions.indexWhere((d) => d.id == data['discussion_id']);
    print("Je suis appeler");
    print(index);
    if (index != -1) {
      setState(() {

        Discussion old = discussions[index];
        Discussion updated = Discussion(
          id: old.id,
          name: old.name,
          createdAt: old.createdAt,
          updatedAt: DateTime.now(),
          createdBy: old.createdBy,
          users: old.users,
          lastMessage: {'text': data['message']},
          nbMessagesNotRead: old.nbMessagesNotRead + 1,
        );
        discussions[index] = updated;
      });
    }
  }
}
