import 'dart:io';
import 'package:flutter/material.dart';
import 'package:vezemtitoapp/general/authentication.dart';
import 'package:vezemtitoapp/general/general.dart';
import 'package:vezemtitoapp/widgets/button_login.dart';

class SignLogin extends StatelessWidget {
  const SignLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
      backgroundColor: kPrimary,
      body: SafeArea(
          child: FutureBuilder(
              future: Authentication.initializeFirebase(context: context),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Text('Error initializing Firebase');
                } else if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Spacer(flex: 1),
                        Expanded(
                            flex: 2,
                            child: Text("Přihlášení do aplikace",
                                textAlign: TextAlign.center,  
                                style: TextStyle(
                                    color: kWhite,
                                    height: 1.7,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25))),
                        // TODO logo
                        /* Expanded(
                            flex: 3,
                            child: FittedBox(
                                child: Image.asset("assets/sqr/white_cz.png"))), */
                        Expanded(
                            flex: 3,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  const LoginButton(),
                                  const LoginButton(isGoogle: true),
                                  if (Platform.isIOS)
                                    const LoginButton(isGoogle: false)
                                ])),
                      ]);
                }
                return const Center(child: CircularProgressIndicator());
              })));
}
