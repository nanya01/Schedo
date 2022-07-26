// import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class Users {
  String firstName;
  String lastName;
  String uid;
  String email;
  String? photoUrl;

  Users(
      {required this.firstName,
      required this.lastName,
      required this.uid,
      required this.email,
      this.photoUrl});

  static Users fromSnapshot(DocumentSnapshot snapshot) {
    var snapshots = snapshot.data() as Map<String, dynamic>;

    return Users(
      firstName: snapshots["firstName"],
      lastName: snapshots["lastName"],
      uid: snapshots["uid"],
      email: snapshots["email"],
      photoUrl: snapshots["photoUrl"],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};

    data["firstName"] = firstName;
    data["lastName"] = lastName;
    data["uid"] = uid;
    data["email"] = email;
    data["photoUrl"] = photoUrl;

    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return '{firstName: $firstName, uid: $uid, email: $email}';
  }
}
