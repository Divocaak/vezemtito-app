import 'package:firebase_auth/firebase_auth.dart';

class MyUser {
  final User fbaUser;
  final bool? isAdmin;
  final int? status;

  MyUser(this.fbaUser, [this.isAdmin, this.status]);
}
