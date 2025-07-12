import 'package:equatable/equatable.dart';

import 'package:proklinik_one/models/app_constants/account_type.dart';
import 'package:proklinik_one/models/app_constants/app_permission.dart';
import 'package:proklinik_one/models/app_constants/patient_progress_status.dart';
import 'package:proklinik_one/models/app_constants/subscription_plan.dart';
import 'package:proklinik_one/models/app_constants/visit_status.dart';
import 'package:proklinik_one/models/app_constants/visit_type.dart';

class AppConstants extends Equatable {
  final List<AccountType> accountTypes;
  final List<VisitStatus> visitStatus;
  final List<VisitType> visitType;
  final List<SubscriptionPlan> subscriptionPlan;
  final List<PatientProgressStatus> patientProgressStatus;
  final List<AppPermission> appPermission;

  const AppConstants({
    required this.accountTypes,
    required this.visitStatus,
    required this.visitType,
    required this.subscriptionPlan,
    required this.patientProgressStatus,
    required this.appPermission,
  });

  AppConstants copyWith({
    List<AccountType>? accountTypes,
    List<VisitStatus>? visitStatus,
    List<VisitType>? visitType,
    List<SubscriptionPlan>? subscriptionPlan,
    List<PatientProgressStatus>? patientProgressStatus,
    List<AppPermission>? appPermission,
  }) {
    return AppConstants(
      accountTypes: accountTypes ?? this.accountTypes,
      visitStatus: visitStatus ?? this.visitStatus,
      visitType: visitType ?? this.visitType,
      subscriptionPlan: subscriptionPlan ?? this.subscriptionPlan,
      patientProgressStatus:
          patientProgressStatus ?? this.patientProgressStatus,
      appPermission: appPermission ?? this.appPermission,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'accountTypes': accountTypes.map((x) => x.toJson()).toList(),
      'visitStatus': visitStatus.map((x) => x.toJson()).toList(),
      'visitType': visitType.map((x) => x.toJson()).toList(),
      'subscriptionPlan': subscriptionPlan.map((x) => x.toJson()).toList(),
      'patientProgressStatus':
          patientProgressStatus.map((x) => x.toJson()).toList(),
      'appPermission': appPermission.map((x) => x.toJson()).toList(),
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
      subscriptionPlan: List<SubscriptionPlan>.from(
        (map['subscriptionPlan'] as List<dynamic>).map<SubscriptionPlan>(
          (x) => SubscriptionPlan.fromJson(x as Map<String, dynamic>),
        ),
      ),
      patientProgressStatus: List<PatientProgressStatus>.from(
        (map['patientProgressStatus'] as List<dynamic>)
            .map<PatientProgressStatus>(
          (x) => PatientProgressStatus.fromJson(x as Map<String, dynamic>),
        ),
      ),
      appPermission: List<AppPermission>.from(
        (map['appPermission'] as List<dynamic>).map<AppPermission>(
          (x) => AppPermission.fromJson(x as Map<String, dynamic>),
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
        visitType,
        subscriptionPlan,
        patientProgressStatus,
        appPermission,
      ];
}
