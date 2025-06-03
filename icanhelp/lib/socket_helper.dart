

import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

 void connectToWebSocket(int discussionId,String type, void callback(data)) async {
  final storage = FlutterSecureStorage();
  final token = await storage.read(key: 'access_token');
  final uri = Uri.parse(
    'ws://4a75-46-193-67-60.ngrok-free.app/ws/chat/${discussionId}/?token=$token',
  );
  final channel = WebSocketChannel.connect(uri);
  await channel.ready;

  channel.stream.listen((message){
    final data = json.decode(message);
    if(data['type'] != null && data['type'] == type){
      callback(data);
    }
  },
      onError: (error) {
        print("Erreur WebSocket: $error");
        },
      onDone: () {
        print("WebSocket fermé");
  });
}
