import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class StorageMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // adding image to firebase storage
  Future<String> uploadImageToStorage(String childName, Uint8List file, bool isPost) async {
  try {
    print('Uploading image...');
    // creating location to our firebase storage
    String id = const Uuid().v1();
    Reference ref = _storage.ref().child(childName).child(id);//.child(_auth.currentUser!.uid);

    // putting in uint8list format -> Upload task like a future but not future
    UploadTask uploadTask = ref.putData(file);
    print('Image upload task started...');

    TaskSnapshot snapshot = await uploadTask;
    print('Image uploaded successfully...');

    String downloadUrl = await snapshot.ref.getDownloadURL();
    print('Download URL: $downloadUrl');

    return downloadUrl;
  } catch (e) {
    print('Error uploading image: $e');
    // Handle the error or throw an exception
    throw e;
  }
}

}