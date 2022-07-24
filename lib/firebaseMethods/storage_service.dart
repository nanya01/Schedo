import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  String dateUploaded = DateTime.now().millisecondsSinceEpoch.toString();

  Future<String> uploadImageToStorage(XFile? file) async {
    Reference ref = _storage.ref().child("profile picture").child(dateUploaded);

    if (file != null) {
      UploadTask uploadTask = ref.putFile(File(file.path));
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return Future.value(downloadUrl);
    } else {
      return "";
    }
  }
}
