import 'dart:convert';
import 'dart:async';
import 'dart:math';
import "package:vezemtitoapp/objects/my_user.dart";
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:vezemtitoapp/pages/user_check_page.dart';

class Authentication {
  static MyUser? loggedInUser;

  static Future<FirebaseApp> initializeFirebase(
      {required BuildContext context}) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    final prefs = await SharedPreferences.getInstance();
    final bool? loggedViaGoogle = prefs.getBool("loggedViaGoogle");
    if (loggedViaGoogle != null) {
      User? autoUser = await loginUser(context, loggedViaGoogle);
      if (autoUser != null) {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => UserCheckPage(user: autoUser)));
      }
    }

    return firebaseApp;
  }

  static Future<AuthCredential?> signInWithGoogle(BuildContext context) async {
    GoogleSignInAccount? googleSignInAccount;
    try {
      googleSignInAccount = await GoogleSignIn().signIn();
    } catch (error) {
      print("asd === $error");
      ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(content: 'Error: $error'));
    }

    AuthCredential? credential;
    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loggedViaGoogle", true);

    return credential;
  }

  static Future<AuthCredential?> signInWithApple(BuildContext context) async {
    final rawNonce = generateNonce();
    AuthorizationCredentialAppleID? appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: AppleIDAuthorizationScopes.values,
          nonce: sha256ofString(rawNonce));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          Authentication.customSnackBar(content: 'Error: $error'));
    }

    AuthCredential? credential;
    if (appleCredential != null) {
      credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken, rawNonce: rawNonce);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("loggedViaGoogle", false);

    return credential;
  }

  static Future<User?> loginUser(BuildContext context, bool isGoogle) async {
    User? user;

    AuthCredential? credential =
        await (isGoogle ? signInWithGoogle(context) : signInWithApple(context));

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential!);

      user = userCredential.user;
    } on FirebaseAuthException catch (e) {
      print(e);
      if (e.code == 'account-exists-with-different-credential') {
        ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
                content:
                    'The account already exists with a different credential.'));
      } else if (e.code == 'invalid-credential') {
        await GoogleSignIn()
            .disconnect()
            .whenComplete(() async => await FirebaseAuth.instance.signOut());
        ScaffoldMessenger.of(context).showSnackBar(
            Authentication.customSnackBar(
                content:
                    'Error occurred while accessing credentials. Try again.'));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(Authentication.customSnackBar(
          content: "Error occurred using Google Sign-In. Try again."));
    }

    loggedInUser = user != null ? MyUser(user) : null;

    return user;
  }

  static SnackBar customSnackBar({required String content}) => SnackBar(
      content: Text(content,
          style: const TextStyle(color: Colors.redAccent, letterSpacing: 0.5)));

  static Future<void> signOut(
      {required BuildContext context, required User? user}) async {
    try {
      await GoogleSignIn()
          .disconnect()
          .whenComplete(() async => await FirebaseAuth.instance.signOut());

      final prefs = await SharedPreferences.getInstance();
      await prefs.remove("loggedViaGoogle");

      loggedInUser = null;
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(Authentication.customSnackBar(content: e.toString()));
    }
  }

  static String generateNonce(
          [int length = 32,
          String charset =
              "0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._"]) =>
      List.generate(
              length, (_) => charset[Random.secure().nextInt(charset.length)])
          .join();

  static String sha256ofString(String input) =>
      sha256.convert(utf8.encode(input)).toString();
}
