import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_app/global/global.dart';
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

  void setTask(String title, String category) async {
    String dateTime = DateTime.now().millisecondsSinceEpoch.toString();
    var currentDate = DateTime.now();
    int timeCreatedHour = currentDate.hour;
    int timeCreatedMinute = currentDate.minute;

    await firestore
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("tasks")
        .doc(dateTime)
        .set({
      "title": title,
      "category": category,
      "timeCreated": "$timeCreatedHour:$timeCreatedMinute",
      "status": false
    });
  }
}
