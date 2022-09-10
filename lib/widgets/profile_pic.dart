import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vezemtitoapp/general/general.dart';

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key, required User? user})
      : _user = user,
        super(key: key);

  final User? _user;

  @override
  Widget build(BuildContext context) => FutureBuilder<String?>(
      future: General.getProfPic(_user),
      builder: (context, snapshot) {
        return snapshot.data != null
            ? ClipOval(
                child: Material(
                    color: Colors.blueGrey.withOpacity(0.3),
                    child:
                        Image.network(snapshot.data!, fit: BoxFit.fitHeight)))
            : ClipOval(
                child: Material(
                    color: Colors.blueGrey.withOpacity(0.3),
                    child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Icon(Icons.person,
                            size: 60, color: Colors.blueGrey))));
      });
}
