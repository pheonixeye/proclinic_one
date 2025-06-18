import 'package:equatable/equatable.dart';

import 'package:proklinik_one/models/account_type.dart';

class AppConstants extends Equatable {
  final List<AccountType> accountTypes;
  const AppConstants({
    required this.accountTypes,
  });

  AppConstants copyWith({
    List<AccountType>? accountTypes,
  }) {
    return AppConstants(
      accountTypes: accountTypes ?? this.accountTypes,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountTypes': accountTypes.map((x) => x.toJson()).toList(),
    };
  }

  factory AppConstants.fromJson(Map<String, dynamic> map) {
    return AppConstants(
      accountTypes: List<AccountType>.from(
        (map['accountTypes'] as List<int>).map<AccountType>(
          (x) => AccountType.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [accountTypes];
}
