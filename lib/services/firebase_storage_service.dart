import 'package:firebase_storage/firebase_storage.dart';

class FirebaseStorageService {
  FirebaseStorageService._();

  static final FirebaseStorageService instance = FirebaseStorageService._();

  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> getUrl(String fileName) async {
    try {
      final ref = _storage.ref(fileName);
      return await ref.getDownloadURL();
    } catch (e) {
      print("Error obteniendo URL de Firebase Storage: $e");
      return '';
    }
  }
}
