class User {
  final String id;

  User({required this.id});
}

abstract class AuthServiceInterface {
  bool isUserLoggedIn();
  User getUser();
}