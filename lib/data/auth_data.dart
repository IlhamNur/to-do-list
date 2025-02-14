import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_to_do_list/data/firestore.dart';

abstract class AuthenticationDatasource {
  Future<void> register(String email, String password, String passwordConfirm);
  Future<void> login(String email, String password);
}

class AuthenticationRemote extends AuthenticationDatasource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
    } catch (e) {
      throw Exception("Login gagal: ${e.toString()}");
    }
  }

  @override
  Future<void> register(String email, String password, String passwordConfirm) async {
    if (passwordConfirm != password) {
      throw Exception("Konfirmasi password tidak sesuai.");
    }

    try {
      await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim()).then((value) {
        FirestoreDatasource().createUser(email);
      });
    } catch (e) {
      throw Exception("Registrasi gagal: ${e.toString()}");
    }
  }
}
