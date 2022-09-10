import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

// URGENT before build
//String remoteUrl = "https://app.renttrio.com/api/renttrio/v1/";
String remoteUrl = "http://10.0.2.2/vezemtito-app-serverside/";

Color kPrimary = Colors.green;
Color kWhite = Colors.white70;
Color kSecondary = const Color(0xffdb6e00);

class General {
  static Future<String?> getProfPic(User? user) async {
    if (user != null) {
      String? id;
      for (UserInfo element in user.providerData) {
        if (element.providerId == "google.com") {
          id = element.photoURL!;
          break;
        }
      }
      return id;
    }
  }

  static Future<String> getFCMTokenFromFirebase() async =>
      await FirebaseMessaging.instance.getToken() ?? "";
}
