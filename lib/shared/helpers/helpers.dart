import 'dart:math';

String generateRandomString(int len) {
  const _allowedChars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  Random _rnd = Random();

  return String.fromCharCodes(Iterable.generate(
      len, (_) =>
      _allowedChars.codeUnitAt(_rnd.nextInt(_allowedChars.length))));
}