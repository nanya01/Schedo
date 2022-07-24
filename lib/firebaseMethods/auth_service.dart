import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:todo_app/firebaseMethods/cloud_firestore_service.dart';
import 'package:todo_app/firebaseMethods/storage_service.dart';
import 'package:todo_app/global/global.dart';

import '../model/user.dart';

class AuthService {
  final CloudFirestoreService _cloudFirestoreService = CloudFirestoreService();
  final StorageService _storageService = StorageService();

  Future<String> signUpUser(
      String firstName, String lastName, String email, String password,
      {XFile? file}) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        String userId = "";
        await firebaseAuth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((userCredential) {
          userId = userCredential.user!.uid;
        });
        String photoUrl = await _storageService
            .uploadImageToStorage(file)
            .catchError((error) {
          return error;
        });
        Users users = Users(
            firstName: firstName,
            lastName: lastName,
            uid: userId,
            email: email,
            photoUrl: photoUrl);

        _cloudFirestoreService.saveUserData(users);

        return Future.value("success");
      } else {
        return Future.value("email or password is empty");
      }
    } on FirebaseAuthException catch (e) {
      return Future.value(e.message);
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await firebaseAuth.signInWithEmailAndPassword(
            email: email, password: password);

        return Future.value("success");
      } else {
        return Future.value("email or password is empty");
      }
    } on FirebaseAuthException catch (e) {
      return Future.value(e.message.toString());
    }
  }

  Future<Users> getUserDetails() async {
    String userId = firebaseAuth.currentUser!.uid;
    DocumentSnapshot snapshot =
        await _cloudFirestoreService.fetchUserDetails(userId);

    return Users.fromSnapshot(snapshot);
  }
}
