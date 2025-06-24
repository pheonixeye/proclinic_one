import 'package:equatable/equatable.dart';

import 'package:proklinik_one/models/account_type.dart';
import 'package:proklinik_one/models/visit_status.dart';
import 'package:proklinik_one/models/visit_type.dart';

class AppConstants extends Equatable {
  final List<AccountType> accountTypes;
  final List<VisitStatus> visitStatus;
  final List<VisitType> visitType;
  const AppConstants({
    required this.accountTypes,
    required this.visitStatus,
    required this.visitType,
  });

  AppConstants copyWith({
    List<AccountType>? accountTypes,
    List<VisitStatus>? visitStatus,
    List<VisitType>? visitType,
  }) {
    return AppConstants(
      accountTypes: accountTypes ?? this.accountTypes,
      visitStatus: visitStatus ?? this.visitStatus,
      visitType: visitType ?? this.visitType,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountTypes': accountTypes.map((x) => x.toJson()).toList(),
      'visitStatus': visitStatus.map((x) => x.toJson()).toList(),
      'visitType': visitType.map((x) => x.toJson()).toList(),
    };
  }

  factory AppConstants.fromJson(Map<String, dynamic> map) {
    return AppConstants(
      accountTypes: List<AccountType>.from(
        (map['accountTypes'] as List<dynamic>).map<AccountType>(
          (x) => AccountType.fromJson(x as Map<String, dynamic>),
        ),
      ),
      visitStatus: List<VisitStatus>.from(
        (map['visitStatus'] as List<dynamic>).map<VisitStatus>(
          (x) => VisitStatus.fromJson(x as Map<String, dynamic>),
        ),
      ),
      visitType: List<VisitType>.from(
        (map['visitType'] as List<dynamic>).map<VisitType>(
          (x) => VisitType.fromJson(x as Map<String, dynamic>),
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
