import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class FirebaseVideoService {
  FirebaseVideoService._internal();

  static final FirebaseVideoService instance =
      FirebaseVideoService._internal();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      debugPrint("Video no encontrado en Firebase: $path");
      return "";
    }
  }
}
