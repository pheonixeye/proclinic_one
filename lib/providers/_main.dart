import 'package:flutter/material.dart';
import 'package:proklinik_one/core/api/auth/api_auth.dart';
import 'package:proklinik_one/core/api/clinics_api.dart';
import 'package:proklinik_one/core/api/constants_api.dart';
import 'package:proklinik_one/core/api/doctor_api.dart';
import 'package:proklinik_one/core/api/doctor_profile_items_api.dart';
import 'package:proklinik_one/core/api/doctor_subscription_info_api.dart';
import 'package:proklinik_one/core/api/forms_api.dart';
import 'package:proklinik_one/core/api/patients_api.dart';
import 'package:proklinik_one/core/api/visits_api.dart';
import 'package:proklinik_one/models/doctor_items/doctor_drug_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_lab_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_procedure_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_rad_item.dart';
import 'package:proklinik_one/models/doctor_items/doctor_supply_item.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/providers/px_app_constants.dart';
import 'package:proklinik_one/providers/px_auth.dart';
import 'package:proklinik_one/providers/px_clinics.dart';
import 'package:proklinik_one/providers/px_doc_subscription_info.dart';
import 'package:proklinik_one/providers/px_doctor.dart';
import 'package:proklinik_one/providers/px_doctor_profile_items.dart';
import 'package:proklinik_one/providers/px_forms.dart';
import 'package:proklinik_one/providers/px_locale.dart';
import 'package:proklinik_one/providers/px_patients.dart';
import 'package:proklinik_one/providers/px_visits.dart';
import 'package:proklinik_one/router/router.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

final List<SingleChildWidget> providers = [
  ChangeNotifierProvider.value(
    value: AppRouter.router.routeInformationProvider,
  ),
  ChangeNotifierProvider(
    create: (context) => PxLocale(),
  ),
  ChangeNotifierProvider(
    create: (context) => PxAppConstants(
      api: const ConstantsApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxAuth(
      api: const AuthApi(),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxDoctor(
      api: DoctorApi(doc_id: context.read<PxAuth>().doc_id),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxDocSubscriptionInfo(
      api: DoctorSubscriptionInfoApi(doc_id: context.read<PxAuth>().doc_id),
    ),
  ),
  // ...ProfileSetupItem.values.map((e) {
  //   return ChangeNotifierProvider(
  //     create: (context) => PxDoctorProfileItems(
  //       api: DoctorProfileItemsApi(
  //         doc_id: context.read<PxAuth>().doc_id,
  //         item: e,
  //       ),
  //     ),
  //   );
  // }),
  //profile items providers
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.drugs),
    create: (context) => PxDoctorProfileItems<DoctorDrugItem>(
      api: DoctorProfileItemsApi<DoctorDrugItem>(
        doc_id: context.read<PxAuth>().doc_id,
        item: ProfileSetupItem.drugs,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.labs),
    create: (context) => PxDoctorProfileItems<DoctorLabItem>(
      api: DoctorProfileItemsApi<DoctorLabItem>(
        doc_id: context.read<PxAuth>().doc_id,
        item: ProfileSetupItem.labs,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.rads),
    create: (context) => PxDoctorProfileItems<DoctorRadItem>(
      api: DoctorProfileItemsApi<DoctorRadItem>(
        doc_id: context.read<PxAuth>().doc_id,
        item: ProfileSetupItem.rads,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.supplies),
    create: (context) => PxDoctorProfileItems<DoctorSupplyItem>(
      api: DoctorProfileItemsApi<DoctorSupplyItem>(
        doc_id: context.read<PxAuth>().doc_id,
        item: ProfileSetupItem.supplies,
      ),
    ),
  ),
  ChangeNotifierProvider(
    key: ValueKey(ProfileSetupItem.procedures),
    create: (context) => PxDoctorProfileItems<DoctorProcedureItem>(
      api: DoctorProfileItemsApi<DoctorProcedureItem>(
        doc_id: context.read<PxAuth>().doc_id,
        item: ProfileSetupItem.procedures,
      ),
    ),
  ),
  //profile items providers##
  ChangeNotifierProvider(
    create: (context) => PxClinics(
      api: ClinicsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxPatients(
      api: PatientsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxForms(
      api: FormsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
  ChangeNotifierProvider(
    create: (context) => PxVisits(
      api: VisitsApi(
        doc_id: context.read<PxAuth>().doc_id,
      ),
    ),
  ),
];
