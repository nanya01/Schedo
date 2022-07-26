import '../firebaseMethods/auth_service.dart';
import '../model/user.dart';

class HomeViewModel {
  Users? _users;
  Users get getUsers =>
      _users ?? Users(firstName: "", lastName: "", uid: "", email: "");

  Future<void> fetchUserDetails() async {
    final AuthService _authService = AuthService();
    Users users = await _authService.getUserDetails();
    _users = users;
    print("Users $_users");
    print("uid: ${_users!.uid}");
  }
}
