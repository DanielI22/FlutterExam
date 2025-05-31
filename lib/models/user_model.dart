import 'package:flutter_exam/constants/app_constants.dart';

class AppUser {
  final String uid;
  final String email;
  final String name;
  final DateTime createdAt;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.createdAt,
  });

  factory AppUser.fromMap(Map<String, dynamic> map, String uid) {
    return AppUser(
      uid: uid,
      email: map[AppUserConstants.email] ?? '',
      name: map[AppUserConstants.name] ?? '',
      createdAt: DateTime.parse(map[AppUserConstants.createdAt]),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppUserConstants.email: email,
      AppUserConstants.name: name,
      AppUserConstants.createdAt: createdAt.toIso8601String(),
    };
  }
}
