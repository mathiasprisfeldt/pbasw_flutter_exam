import 'package:pbasw_flutter_exam/types/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  Future<void> updateUser(String userID, User user) {
    var doc = Firestore.instance.collection("users").document(userID);
    var data = user.toJson();

    return doc.setData(data, merge: true);
  }

  void removeUser(String userId) {
    Firestore.instance.collection("users").document(userId).delete();
  }

  getUserSnapshots() => Firestore.instance.collection("users").snapshots();
}
