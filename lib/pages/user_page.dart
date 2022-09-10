import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:vezemtitoapp/general/authentication.dart';
import 'package:vezemtitoapp/general/general.dart';
import 'package:vezemtitoapp/pages/sign_in.dart';
import 'package:vezemtitoapp/widgets/button_main.dart';
import 'package:vezemtitoapp/widgets/profile_pic.dart';

class UserPage extends StatefulWidget {
  const UserPage({Key? key, User? user})
      : _user = user,
        super(key: key);

  final User? _user;

  @override
  UserPageState createState() => UserPageState();
}

class UserPageState extends State<UserPage> {
  late bool _isSigningOut;

  @override
  void initState() {
    _isSigningOut = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text("Uživatel"), backgroundColor: kPrimary),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
            const SizedBox(height: 50),
            ProfilePic(user: widget._user),
            const SizedBox(height: 15),
            Text("(${widget._user?.email! ?? "email"})",
                style: const TextStyle(color: Colors.grey, fontSize: 20)),
            const SizedBox(height: 15),
            signOutBtn(),
            const SizedBox(height: 15),
            FutureBuilder(
                future: appInfo(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data!);
                  } else if (snapshot.hasError) {
                    print(" ===== ${snapshot.error}");
                    return const Text("error");
                  }
                  return const CircularProgressIndicator();
                }),
            /* TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CachedPdfViewer(
                        url: "https://app.renttrio.com/asset/pdf/gdpr.pdf"))),
                child: Text("GDPR", style: TextStyle(color: kPrimary))),
            TextButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => const CachedPdfViewer(
                        url: "https://app.renttrio.com/asset/pdf/vop.pdf"))),
                child: Text("Všeobecné obchodní podmínky",
                    style: TextStyle(color: kPrimary))) */
          ])))));

  Widget signOutBtn() => _isSigningOut
      ? const CircularProgressIndicator()
      : MainButton(
          bgColor: Colors.redAccent,
          label: "Odhlásit se",
          onTap: () async {
            if (widget._user != null) {
              setState(() => _isSigningOut = true);
              await Authentication.signOut(
                  context: context, user: widget._user);
              setState(() => _isSigningOut = false);
            }

            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const SignLogin()),
                (r) => false);
          });

  Future<String> appInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return "verze ${packageInfo.version} (build ${packageInfo.buildNumber})";
  }
}
