import 'package:equatable/equatable.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/models/clinic/clinic.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/user.dart';
import 'package:proklinik_one/models/visits/_visit.dart';

class SupplyMovement extends Equatable {
  final String id;
  final Clinic clinic;
  final DoctorSupplyItem supply_item;
  final Visit? visit;
  final User added_by;
  final User? updated_by;
  final String movement_type;
  final String reason;
  final double movement_quantity;
  final double movement_amount;
  final bool auto_add;
  final int number_of_updates;

  const SupplyMovement({
    required this.id,
    required this.clinic,
    required this.supply_item,
    this.visit,
    this.updated_by,
    required this.added_by,
    required this.movement_type,
    required this.reason,
    required this.movement_quantity,
    required this.movement_amount,
    required this.auto_add,
    required this.number_of_updates,
  });

  SupplyMovement copyWith({
    String? id,
    Clinic? clinic,
    DoctorSupplyItem? supply_item,
    Visit? visit,
    User? added_by,
    User? updated_by,
    String? movement_type,
    String? reason,
    double? movement_quantity,
    double? movement_amount,
    bool? auto_add,
    int? number_of_updates,
  }) {
    return SupplyMovement(
      id: id ?? this.id,
      clinic: clinic ?? this.clinic,
      supply_item: supply_item ?? this.supply_item,
      visit: visit ?? this.visit,
      added_by: added_by ?? this.added_by,
      updated_by: updated_by ?? this.updated_by,
      movement_type: movement_type ?? this.movement_type,
      reason: reason ?? this.reason,
      movement_quantity: movement_quantity ?? this.movement_quantity,
      movement_amount: movement_amount ?? this.movement_amount,
      auto_add: auto_add ?? this.auto_add,
      number_of_updates: number_of_updates ?? this.number_of_updates,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'clinic': clinic.toJson(),
      'supply_item': supply_item.toJson(),
      'visit': visit?.toJson(),
      'added_by': added_by.toJson(),
      'updated_by': updated_by?.toJson(),
      'movement_type': movement_type,
      'reason': reason,
      'movement_quantity': movement_quantity,
      'movement_amount': movement_amount,
      'auto_add': auto_add,
      'number_of_updated': number_of_updates,
    };
  }

  factory SupplyMovement.fromJson(Map<String, dynamic> map) {
    return SupplyMovement(
      id: map['id'] as String,
      clinic: Clinic.fromJson(map['clinic'] as Map<String, dynamic>),
      supply_item:
          DoctorSupplyItem.fromJson(map['supply_item'] as Map<String, dynamic>),
      visit: map['visit'] != null
          ? Visit.fromJson(map['visit'] as Map<String, dynamic>)
          : null,
      updated_by: map['updated_by'] != null
          ? User.fromJson(map['updated_by'] as Map<String, dynamic>)
          : null,
      added_by: User.fromJson(map['added_by'] as Map<String, dynamic>),
      movement_type: map['movement_type'] as String,
      reason: map['reason'] as String,
      movement_quantity: map['movement_quantity'] as double,
      movement_amount: map['movement_amount'] as double,
      auto_add: map['auto_add'] as bool,
      number_of_updates: map['number_of_updated'] as int,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      clinic,
      supply_item,
      visit,
      movement_type,
      added_by,
      reason,
      movement_quantity,
      movement_amount,
      auto_add,
      updated_by,
      number_of_updates,
    ];
  }

  factory SupplyMovement.fromRecordModel(RecordModel e) {
    return SupplyMovement(
      id: e.id,
      clinic: Clinic.fromJson(e.get<RecordModel>('expand.clinic_id').toJson()),
      supply_item: DoctorSupplyItem.fromJson(
          e.get<RecordModel>('expand.supply_item_id').toJson()),
      added_by: User.fromJson({
        ...e.get<RecordModel>('expand.added_by_id').toJson(),
        'account_type': e
            .get<RecordModel>('expand.added_by_id.expand.account_type_id')
            .toJson(),
        'app_permissions': e
            .get<List<RecordModel>>(
                'expand.added_by_id.expand.app_permissions_ids')
            .map((x) => x.toJson())
            .toList(),
      }),
      movement_type: e.getStringValue('movement_type'),
      reason: e.getStringValue('reason'),
      movement_quantity: e.getDoubleValue('movement_quantity'),
      movement_amount: e.getDoubleValue('movement_amount'),
      auto_add: e.getBoolValue('auto_add'),
      visit: e.get<RecordModel?>('expand.related_visit_id') == null
          ? null
          : Visit.fromJson(
              e.get<RecordModel?>('expand.related_visit_id')!.toJson()),
      updated_by: e.get<RecordModel?>('expand.updated_by_id') == null
          ? null
          : User.fromJson({
              ...e.get<RecordModel>('expand.updated_by_id').toJson(),
              'account_type': e
                  .get<RecordModel>(
                      'expand.updated_by_id.expand.account_type_id')
                  .toJson(),
              'app_permissions': e
                  .get<List<RecordModel>>(
                      'expand.updated_by_id.expand.app_permissions_ids')
                  .map((x) => x.toJson())
                  .toList(),
            }),
      number_of_updates: e.getIntValue('number_of_updates'),
    );
  }
}
