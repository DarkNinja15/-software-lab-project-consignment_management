import 'dart:typed_data';

// import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  FirebaseStorage firebaseStorage = FirebaseStorage.instance;

  // add image to firebase storage
  Future<String> uploadImageToStorage(String childname, Uint8List file) async {
    try {
      Reference ref =
          firebaseStorage.ref().child(childname).child(const Uuid().v4());

      // when it is a post we create diffrent uid for diffrent posts.

      // putting file in uid folder.
      UploadTask uploadTask = ref.putData(file);
      // await the uploadtask
      TaskSnapshot snap = await uploadTask;
      // getting downloadUrl
      String downloadUrl = (await snap.ref.getDownloadURL()).toString();
      return downloadUrl;
    } catch (e) {
      // print(e.toString());
    }
    // create folder name childname and inside that created a folder of userid in which file is stored
    return "";
  }
}
