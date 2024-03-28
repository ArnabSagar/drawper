import 'dart:typed_data';

import 'package:drawper/utils/toastMessage.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final logger = ToastMessage();

  Future<void> uploadFile(
    Uint8List file,
    String fileName,
  ) async {
    try {
      await FirebaseStorage.instance.ref().child(fileName).putData(file);
    } catch (e) {
      logger.toast(message: 'File upload error occured: $e');
    }
  }

  Future<String> getDownloadURL(String fileName) async {
    try {
      return await FirebaseStorage.instance
          .ref()
          .child(fileName)
          .getDownloadURL();
    } catch (e) {
      return "";
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await FirebaseStorage.instance.ref().child(fileName).delete();
    } catch (e) {
      print(e);
    }
  }
}
