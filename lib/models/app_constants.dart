import 'package:equatable/equatable.dart';

import 'package:proklinik_one/models/account_type.dart';
import 'package:proklinik_one/models/visit_status.dart';

class AppConstants extends Equatable {
  final List<AccountType> accountTypes;
  final List<VisitStatus> visitStatus;
  const AppConstants({
    required this.accountTypes,
    required this.visitStatus,
  });

  AppConstants copyWith({
    List<AccountType>? accountTypes,
    List<VisitStatus>? visitStatus,
  }) {
    return AppConstants(
      accountTypes: accountTypes ?? this.accountTypes,
      visitStatus: visitStatus ?? this.visitStatus,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountTypes': accountTypes.map((x) => x.toJson()).toList(),
      'visitStatus': visitStatus.map((x) => x.toJson()).toList(),
    };
  }

  factory AppConstants.fromJson(Map<String, dynamic> map) {
    return AppConstants(
      accountTypes: List<AccountType>.from(
        (map['accountTypes'] as List<int>).map<AccountType>(
          (x) => AccountType.fromJson(x as Map<String, dynamic>),
        ),
      ),
      visitStatus: List<VisitStatus>.from(
        (map['visitStatus'] as List<int>).map<VisitStatus>(
          (x) => VisitStatus.fromJson(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        accountTypes,
        visitStatus,
      ];
}
