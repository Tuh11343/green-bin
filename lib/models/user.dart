import 'package:equatable/equatable.dart';
import 'enums.dart';

class User extends Equatable {
  final int? id;
  final String email;
  final String? passwordHash;
  final String name;
  final UserRole role;
  final int points;
  final String? fcmToken;
  final String? token;
  final String? imageUrl;
  final String? publicImageUrl;

  final bool isSocialLogin;

  const User(
      {this.id,
      required this.email,
      this.passwordHash,
      required this.name,
      this.role = UserRole.resident,
      this.points = 0,
      this.fcmToken,
      this.token,
      this.imageUrl,
      this.publicImageUrl,
      required this.isSocialLogin});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int?,
      email: json['email'] as String,
      passwordHash: json['passwordHash'] as String?,
      name: json['name'] as String,
      role: UserRoleExtension.fromJson(json['role'] as String? ?? 'resident'),
      points: json['points'] as int? ?? 0,
      fcmToken: json['fcmToken'] as String?,
      token: json['token'] as String?,
      imageUrl: json['imageUrl'] as String?,
      publicImageUrl: json['publicImageUrl'] as String?,
      isSocialLogin: json['isSocialLogin'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'passwordHash': passwordHash,
      'name': name,
      'role': role.toJson(),
      'points': points,
      'fcmToken': fcmToken,
      'token': token,
      'imageUrl': imageUrl,
      'publicImageUrl': publicImageUrl,
      'isSocialLogin': isSocialLogin,
    };
  }

  User copyWith({
    int? id,
    String? email,
    String? passwordHash,
    String? name,
    UserRole? role,
    int? points,
    String? fcmToken,
    String? token,
    String? imageUrl,
    String? publicImageUrl,
    bool? isSocialLogin,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      passwordHash: passwordHash ?? this.passwordHash,
      name: name ?? this.name,
      role: role ?? this.role,
      points: points ?? this.points,
      fcmToken: fcmToken ?? this.fcmToken,
      token: token ?? this.token,
      imageUrl: imageUrl ?? this.imageUrl,
      publicImageUrl: publicImageUrl ?? this.publicImageUrl,
      isSocialLogin: isSocialLogin ?? this.isSocialLogin,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        passwordHash,
        name,
        role,
        points,
        fcmToken,
        token,
        imageUrl,
        publicImageUrl,
        isSocialLogin,
      ];
}
