import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/app_profile_setup/pages/profile_item_page/logic/profile_setup_item_enum.dart';

///[DoctorDrugItem] - [DoctorLabItem] - [DoctorRadItem] - [DoctorProcedureItem] - [DoctorSupplyItem]
abstract class DoctorItem {
  const DoctorItem({
    required this.id,
    required this.item,
    required this.name_en,
    required this.name_ar,
  });

  final ProfileSetupItem item;
  final String id;
  final String name_en;
  final String name_ar;

  Map<String, dynamic> toJson();
}
