import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../firebaseMethods/auth_service.dart';
import '../global/global.dart';
import '../model/user.dart';

class HomeViewModel with ChangeNotifier {
  Users? _users;
  int completedTasks = 0;

  int get getCompletedTasksLength => completedTasks;
  Users get getUsers =>
      _users ??
      Users(firstName: "", lastName: "", uid: "", email: "", photoUrl: null);

  Future<void> fetchUserDetails() async {
    final AuthService _authService = AuthService();
    Users users = await _authService.getUserDetails();
    _users = users;
    notifyListeners();
    print("Users $_users");
    print("uid: ${_users!.uid}");
  }

  void getNumberOfCompletedTasks() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(firebaseAuth.currentUser!.uid)
        .collection("tasks")
        .where("status", isEqualTo: true)
        .get()
        .then((value) => completedTasks = value.size);

    print("Completed Tasks $completedTasks");

    notifyListeners();
  }
}
