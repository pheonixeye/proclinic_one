import 'package:proklinik_one/models/bookkeeping/bookkeeping_name.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/supplies/clinic_inventory_item.dart';
import 'package:proklinik_one/models/supplies/supply_movement.dart';
import 'package:proklinik_one/models/supplies/supply_movement_dto.dart';
import 'package:proklinik_one/models/supplies/supply_movement_type.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';
import 'package:proklinik_one/providers/px_auth.dart';

class SupplyMovementTransformer {
  const SupplyMovementTransformer();

  ClinicInventoryItem toClinicInventoryItem(
    SupplyMovement supplyMovement,
    ClinicInventoryItem inventoryItem,
  ) {
    double? _newAvailableQuantity;
    if (supplyMovement.movement_type == SupplyMovementType.IN_OUT.name) {
      _newAvailableQuantity =
          inventoryItem.available_quantity - supplyMovement.movement_quantity;
    } else if (supplyMovement.movement_type == SupplyMovementType.OUT_IN.name) {
      _newAvailableQuantity =
          inventoryItem.available_quantity + supplyMovement.movement_quantity;
    } else {
      //SupplyMovementType.IN_IN
      //todo: when to add && when to subtract
      if (supplyMovement.reason.contains('من')) {
        _newAvailableQuantity =
            inventoryItem.available_quantity - supplyMovement.movement_quantity;
      } else {
        _newAvailableQuantity =
            inventoryItem.available_quantity + supplyMovement.movement_quantity;
      }
    }

    return ClinicInventoryItem(
      id: inventoryItem.id,
      clinic_id: supplyMovement.clinic.id,
      supply_item: supplyMovement.supply_item,
      available_quantity: _newAvailableQuantity,
    );
  }

  SupplyMovementDto fromAddSuppliesToVisit(
    VisitData data,
    DoctorSupplyItem item,
    double quantity,
  ) {
    final _amount = quantity * item.selling_price;

    return SupplyMovementDto(
      id: '',
      clinic_id: data.clinic_id,
      supply_item_id: item.id,
      movement_type: SupplyMovementType.IN_OUT.en,
      related_visit_id: data.visit_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      reason: BookkeepingName.visit_supplies_add.name,
      movement_amount: _amount,
      movement_quantity: item.transfer_quantity,
      number_of_updates: 0,
      auto_add: true,
    );
  }

  SupplyMovementDto fromRemoveSuppliesFromVisit(
    VisitData data,
    DoctorSupplyItem item,
    double quantity,
  ) {
    final _amount = -(quantity * item.selling_price);

    return SupplyMovementDto(
      id: '',
      clinic_id: data.clinic_id,
      supply_item_id: item.id,
      movement_type: SupplyMovementType.OUT_IN.en,
      related_visit_id: data.visit_id,
      added_by_id: PxAuth.doc_id_static_getter,
      updated_by_id: '',
      reason: BookkeepingName.visit_supplies_remove.name,
      movement_amount: _amount,
      movement_quantity: item.transfer_quantity,
      number_of_updates: 0,
      auto_add: true,
    );
  }
}
