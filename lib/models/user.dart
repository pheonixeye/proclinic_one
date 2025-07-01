import 'package:equatable/equatable.dart';

import 'package:proklinik_one/models/app_constants/account_type.dart';

class User extends Equatable {
  final String id;
  final String email;
  final AccountType account_type;

  const User({
    required this.id,
    required this.email,
    required this.account_type,
  });

  User copyWith({
    String? id,
    String? email,
    AccountType? accountType,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      account_type: accountType ?? this.account_type,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'email': email,
      'account_type': account_type.toJson(),
    };
  }

  factory User.fromJson(Map<String, dynamic> map) {
    return User(
      id: map['id'] as String,
      email: map['email'] as String,
      account_type:
          AccountType.fromJson(map['account_type'] as Map<String, dynamic>),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [id, email, account_type];
}
