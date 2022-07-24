import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/model/user.dart';

class CloudFirestoreService {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  void saveUserData(Users users) {
    firestore.collection("users").doc(users.uid).set(users.toJson());
  }

  Future<DocumentSnapshot> fetchUserDetails(String uid) async {
    DocumentSnapshot snapshot =
        await firestore.collection("users").doc(uid).get();

    return snapshot;
  }
}
