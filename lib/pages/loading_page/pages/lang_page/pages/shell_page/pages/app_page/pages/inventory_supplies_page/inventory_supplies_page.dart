import 'package:flutter/material.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/functions/dprint.dart';
import 'package:proklinik_one/models/supplies/supply_movement_dto.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/inventory_supplies_page/widgets/supply_movement_dialog.dart';

class InventorySuppliesPage extends StatelessWidget {
  const InventorySuppliesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(context.loc.inventorySupplies),
              ),
              subtitle: const Divider(),
            ),
          ),
          Expanded(
            child: ListView(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: UniqueKey(),
        tooltip: context.loc.newSupplyMovement,
        onPressed: () async {
          final _movement = await showDialog<SupplyMovementDto?>(
            context: context,
            builder: (context) {
              return SupplyMovementDialog();
            },
          );
          if (_movement == null) {
            return;
          }
          //TODO
          prettyPrint(_movement);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
