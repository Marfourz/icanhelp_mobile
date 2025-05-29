import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:icanhelp/models/SendMessage.dart';
import 'package:icanhelp/models/UserProfile.dart';
import 'package:icanhelp/pages/home.dart';
import 'package:icanhelp/services/api_service.dart';
import 'package:icanhelp/services/dio_client.dart';
import 'package:icanhelp/theme.dart';
import 'package:icanhelp/models/Message.dart' as i_message;
import 'package:web_socket_channel/web_socket_channel.dart';

class Messagerie extends StatefulWidget {
  final int discussionId;

  const Messagerie({super.key, required this.discussionId});

  @override
  State<Messagerie> createState() => _MessagerieState();
}

class _MessagerieState extends State<Messagerie> {
  late ApiService apiService;
  final List<types.Message> _messages = [];
  late types.User _user;
  late UserProfile myProfil;
  final storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    final dio = DioClient.getInstance();
    apiService = ApiService(dio);
    _loadMessages();
    _user = types.User(id: '0');
    _connectToWebSocket();
  }

  _loadMyProfil() async {
    myProfil = UserProfile.fromJson(
      json.decode((await storage.read(key: 'myProfile'))!),
    );
    setState(() {
      _user = types.User(id: myProfil.id.toString());
      print(myProfil.id.toString());
    });
  }

  void _loadMessages() async {
    try {
      await _loadMyProfil();
      final messages = await apiService.getDiscussionMessages(
        widget.discussionId,
      );
      setState(() {
        _messages.clear();
        _messages.addAll(messages.map((msg) => _mapMessage(msg)));
      });
    } catch (error) {
      print("Erreur lors du chargement des messages: $error");
    }
  }

  types.Message _mapMessage(i_message.Message msg) {
    return types.TextMessage(
      author: types.User(id: msg.sender.toString()),
      createdAt: msg.createdAt.millisecondsSinceEpoch,
      id: msg.id.toString(),
      text: msg.message,
    );
  }

  void _addMessage(types.Message message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  void _handleSendPressed(types.PartialText message) {
    apiService.sendMessage(
      widget.discussionId,
      SendMessage(message: message.text),
    );
  }

  void _connectToWebSocket() async {
    await _loadMyProfil();
    final token = await storage.read(key: 'access_token');
    final uri = Uri.parse(
      'ws:/5040-46-193-67-60.ngrok-free.app/ws/chat/${widget.discussionId}/?token=$token',
    );
    final channel = WebSocketChannel.connect(uri);

    await channel.ready;

    channel.stream.listen(
      (message) {
        final data = json.decode(message);
        final newMessage = types.TextMessage(
          author:
              data['sender'] == myProfil.id
                  ? _user
                  : types.User(id: "$data['sender']"),
          createdAt: DateTime.now().millisecondsSinceEpoch,
          id: data['id'].toString(),
          text: data['message'].toString(),
        );
        _addMessage(newMessage);
      },
      onError: (error) {
        print("Erreur WebSocket: $error");
      },
      onDone: () {
        print("WebSocket fermé");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messagerie"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed:
              () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomePage(index: 1)),
              ),
        ),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: const DefaultChatTheme(
          inputBackgroundColor: AppColors.primary,
          primaryColor: AppColors.primary,
        ),
      ),
    );
  }
}
