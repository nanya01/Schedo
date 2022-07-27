import 'package:flutter/cupertino.dart';

import '../firebaseMethods/auth_service.dart';
import '../model/user.dart';

class HomeViewModel with ChangeNotifier {
  Users? _users;
  Users get getUsers =>
      _users ?? Users(firstName: "", lastName: "", uid: "", email: "");

  Future<void> fetchUserDetails() async {
    final AuthService _authService = AuthService();
    Users users = await _authService.getUserDetails();
    _users = users;
    notifyListeners();
    print("Users $_users");
    print("uid: ${_users!.uid}");
  }
}
