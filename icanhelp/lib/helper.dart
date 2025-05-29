  import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:icanhelp/models/UserProfile.dart';


loadMyProfil() async {
    final storage = FlutterSecureStorage();
    final myProfil = UserProfile.fromJson(
      json.decode((await storage.read(key: 'myProfile'))!),
    );
    return myProfil;
  }