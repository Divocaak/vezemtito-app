import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vezemtitoapp/general/authentication.dart';
import 'package:vezemtitoapp/pages/homepage.dart';
import 'package:vezemtitoapp/pages/user_check_page.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({Key? key, bool? isGoogle})
      : _isGoogle = isGoogle,
        super(key: key);

  final bool? _isGoogle;

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      margin: const EdgeInsets.only(bottom: 10),
      child: OutlinedButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40)))),
          onPressed: () async {
            if (_isGoogle != null) {
              User? user = await Authentication.loginUser(context, _isGoogle!);

              if (user != null) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => UserCheckPage(user: user)));
              }
            } else {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => HomePage()));
            }
          },
          child: Row(children: [
            if (_isGoogle != null)
              Container(
                  padding: const EdgeInsets.all(10),
                  height: 50,
                  width: 50,
                  child: Image.asset(_isGoogle!
                      ? "assets/google_logo.png"
                      : "assets/apple_logo.png")),
            Expanded(
                child: AutoSizeText(
                    _isGoogle != null
                        ? 'Přihlásit se přes ${_isGoogle! ? "Google" : "Apple"}'
                        : "Vstoupit anonymně",
                    maxLines: 1,
                    minFontSize: 10,
                    style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black54,
                        fontWeight: FontWeight.w600)))
          ])));
}
