import 'package:flutter/material.dart';
import 'package:vezemtitoapp/general/general.dart';
import 'package:vezemtitoapp/objects/my_user.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, MyUser? user})
      : _user = user,
        super(key: key);

  final MyUser? _user;

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(
          backgroundColor: kPrimary, title: const Text("Domovská stránka")),
      floatingActionButton: FloatingActionButton(
          onPressed: () => print("action"),
          backgroundColor: kPrimary,
          child: const Icon(Icons.add, color: Colors.white)),
      body: const SafeArea(child: Center(child: Text("app"))));
}
