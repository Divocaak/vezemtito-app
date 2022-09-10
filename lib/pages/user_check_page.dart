import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserCheckPage extends StatefulWidget {
  const UserCheckPage({Key? key, required User fbaUser})
      : _fbaUser = fbaUser,
        super(key: key);

  final User _fbaUser;

  @override
  State<UserCheckPage> createState() => UserCheckPageState();
}

class UserCheckPageState extends State<UserCheckPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("widget.title")),
      body: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text(widget._fbaUser.uid)])));
}
