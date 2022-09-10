import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vezemtitoapp/firebase_options.dart';
import 'package:vezemtitoapp/pages/sign_in.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((value) => runApp(const RentTrioApp()));
}

class RentTrioApp extends StatelessWidget {
  const RentTrioApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      const MaterialApp(title: 'VezemTi.to', home: SignLogin());
}
