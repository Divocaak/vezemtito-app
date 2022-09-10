import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vezemtitoapp/objects/my_user.dart';
import 'package:vezemtitoapp/pages/home_page.dart';
import 'package:vezemtitoapp/remote/user.dart';

class UserCheckPage extends StatelessWidget {
  const UserCheckPage({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  Widget build(BuildContext context) => Scaffold(
      body: Center(
          child: FutureBuilder<Map<String, dynamic>>(
              future: RemoteUser.checkUser(_user.uid),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  if (snapshot.data!["message"] == null) {
                    if (snapshot.data!["status"] != 0) {
                      Future.delayed(
                          Duration.zero,
                          () => Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                  builder: (builder) => HomePage(
                                      user: MyUser(
                                          _user,
                                          (snapshot.data!["isAdmin"] == 1),
                                          snapshot.data!["status"]))),
                              (r) => false));
                    } else {
                      // TODO error hlášky
                      return Text(
                          "Váš účet má status ${snapshot.data!["status"]}");
                    }
                  } else {
                    return Text(snapshot.data!["message"]);
                  }
                } else if (!snapshot.hasData &&
                    snapshot.connectionState == ConnectionState.done) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text("Někde se stala chyba, zkuste to prosím později."),
                        // TODO user page redir
                        /* TextButton(
                            onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (builder) =>
                                        UserPage(user: _user.fbaUser))),
                            child: const Text("Účet")) */
                      ]);
                } else if (snapshot.hasError) {
                  return Text(
                      "Někde se stala chyba, zkuste to prosím později. Chyba: ${snapshot.error}");
                }
                return const CircularProgressIndicator();
              })));
}
