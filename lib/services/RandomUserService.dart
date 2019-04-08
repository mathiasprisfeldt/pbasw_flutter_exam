import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:pbasw_flutter_exam/types/User.dart';

class RandomUserService {
  static const String apiUrl = "https://randomuser.me/api/";

  List<User> recentUsers;

  Future<List<User>> getUsers(int amount) async {
    http.Response res = await http.get("$apiUrl?results=$amount");

    if (res.statusCode != 200)
      return Future.error("Failed to retrieve $amount users.");

    List decode = jsonDecode(res.body)['results'];

    return recentUsers = decode.map((data) => User.fromJson(data)).toList();
  }
}
