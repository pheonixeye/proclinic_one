// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:proklinik_one/extensions/loc_ext.dart';
import 'package:proklinik_one/models/doctor_items/doctor_lab_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_procedure_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_rad_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/drugs_page/drugs_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/forms_page/forms_page.dart';
import 'package:proklinik_one/pages/loading_page/pages/lang_page/pages/shell_page/pages/app_page/pages/today_visits_page/pages/visit_data_page/widgets/visit_single_items_page.dart';

class VisitDataNavItem extends Equatable {
  final String title;
  final Icon icon;
  final Icon selectedIcon;
  final Widget page;

  const VisitDataNavItem({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });

  @override
  List<Object?> get props => [
        title,
        icon,
        selectedIcon,
        page,
      ];

  static List<VisitDataNavItem> items(BuildContext context) => [
        VisitDataNavItem(
          title: context.loc.visitForms,
          icon: const Icon(Icons.edit_document),
          selectedIcon: const Icon(Icons.edit),
          page: VisitFormsPage(),
        ),
        VisitDataNavItem(
          title: context.loc.visitDrugs,
          icon: const Icon(FontAwesomeIcons.prescription),
          selectedIcon: const Icon(FontAwesomeIcons.prescriptionBottle),
          page: VisitDrugsPage(),
        ),
        VisitDataNavItem(
          title: context.loc.visitLabs,
          icon: const Icon(FontAwesomeIcons.droplet),
          selectedIcon: const Icon(FontAwesomeIcons.notesMedical),
          page: VisitSingleItemsPage<DoctorLabItem>(
            setupItem: ProfileSetupItem.labs,
          ),
        ),
        VisitDataNavItem(
          title: context.loc.visitRads,
          icon: const Icon(FontAwesomeIcons.radiation),
          selectedIcon: const Icon(FontAwesomeIcons.laptopMedical),
          page: VisitSingleItemsPage<DoctorRadItem>(
            setupItem: ProfileSetupItem.rads,
          ),
        ),
        VisitDataNavItem(
          title: context.loc.visitProcedures,
          icon: const Icon(FontAwesomeIcons.userDoctor),
          selectedIcon: const Icon(FontAwesomeIcons.kitMedical),
          page: VisitSingleItemsPage<DoctorProcedureItem>(
            setupItem: ProfileSetupItem.procedures,
          ),
        ),
        VisitDataNavItem(
          title: context.loc.visitSupplies,
          icon: const Icon(FontAwesomeIcons.warehouse),
          selectedIcon: const Icon(FontAwesomeIcons.handHoldingMedical),
          page: VisitSingleItemsPage<DoctorSupplyItem>(
            setupItem: ProfileSetupItem.supplies,
          ),
        ),
      ];
}
