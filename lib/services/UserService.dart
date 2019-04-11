import 'package:pbasw_flutter_exam/types/User.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  static const String collectionName = "users";

  /// With a given UserID and User data it creates or updates a user document in the db.
  Future<void> updateUser(String userID, User user) {
    var doc = Firestore.instance.collection(collectionName).document(userID);
    var data = user.toJson();

    return doc.setData(data, merge: true);
  }

  /// With a given UserID it removes a user from the db.
  void removeUser(String userId) {
    Firestore.instance.collection(collectionName).document(userId).delete();
  }

  /// Used to retrieve the users as snapshot in the user collections.
  getUserSnapshots() =>
      Firestore.instance.collection(collectionName).snapshots();
}
