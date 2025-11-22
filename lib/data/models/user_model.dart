import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phoneNumber;
  final String avatarPath;
  final List<int> watchlist;
  final List<int> history;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phoneNumber,
    required this.avatarPath,
    this.watchlist = const [],
    this.history = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone_number'],
      avatarPath: json['avatar_path'] ?? 'assets/avatars/avatar1.png',
      watchlist: json['watchlist'] != null
          ? List<int>.from(json['watchlist'])
          : [],
      history: json['history'] != null ? List<int>.from(json['history']) : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phoneNumber,
      'avatar_path': avatarPath,
      'watchlist': watchlist,
      'history': history,
    };
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? phoneNumber,
    String? avatarPath,
    List<int>? watchlist,
    List<int>? history,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatarPath: avatarPath ?? this.avatarPath,
      watchlist: watchlist ?? this.watchlist,
      history: history ?? this.history,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, email, phoneNumber, avatarPath, watchlist, history];
}
