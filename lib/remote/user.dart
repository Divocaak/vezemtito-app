import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:vezemtitoapp/general/general.dart';

class RemoteUser {
  static Future<Map<String, dynamic>> checkUser(String uid) async {
    final Response response = await post(
        Uri.parse(Uri.encodeFull("${remoteUrl}userLogin.php")),
        headers: {
          HttpHeaders.contentTypeHeader: "application/json; charset=UTF-8"
        },
        // TODO posílat devId (notifikace)
        body: jsonEncode({"id": uid}));

    Map<String, dynamic> responseData =
        jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode == 200) {
      return {
        "isAdmin": responseData["isAdmin"],
        "status": responseData["status"]
      };
    } else {
      print("checkUser: ${responseData["sql"]}, ${responseData["error"]}");
      return {"message": responseData["message"]};
    }
  }
}
