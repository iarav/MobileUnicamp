import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class Storage {
  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  Future<void> uploadFile(String filePath, String fileName) async {
    File file = File(filePath);

    try {
      await storage.ref('perfilUsuarioFoto/$fileName').putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }

  Future<String?> getProfileImage(String fileName) async {
    try {
      return await storage.ref('perfilUsuarioFoto/$fileName').getDownloadURL();
    } on firebase_core.FirebaseException catch (e) {
      print(e);
      return null;
    }
  }

  Future<void> deleteFile(String fileName) async {
    try {
      await storage.ref('perfilUsuarioFoto/$fileName').delete();
    } on firebase_core.FirebaseException catch (e) {
      print(e);
    }
  }
}
