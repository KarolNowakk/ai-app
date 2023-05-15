import 'package:app2/shared/auth/domain/service.dart' as domain;
import 'package:firebase_auth/firebase_auth.dart';

class AuthService implements domain.AuthServiceInterface{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  bool isUserLoggedIn() {
    return _auth.currentUser != null;
  }

  @override
  domain.User getUser() {
    final user = _auth.currentUser;
    return domain.User(id: user!.uid);
  }
}