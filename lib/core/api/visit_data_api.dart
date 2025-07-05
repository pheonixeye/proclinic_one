import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/_api_result.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/doctor_items/profile_setup_item.dart';
import 'package:proklinik_one/models/visit_data/visit_data.dart';
import 'package:proklinik_one/models/visit_data/visit_form_item.dart';

class VisitDataApi {
  final String doc_id;
  final String visit_id;

  VisitDataApi({
    required this.doc_id,
    required this.visit_id,
  });

  late final String collection = '${doc_id}__visit__data';

  late final String forms_data_collection = '${doc_id}__visit__formdata';

  final String _expand =
      'patient_id, labs_ids, rads_ids, procedures_ids, drugs_ids, supplies_ids, forms_data_ids, forms_data_ids.form_id';

  Future<ApiResult<VisitData>> fetchVisitData() async {
    try {
      final _result =
          await PocketbaseHelper.pb.collection(collection).getFirstListItem(
                "visit_id = '$visit_id'",
                expand: _expand,
              );

      final _visitData = VisitData.fromRecordModel(_result);

      return ApiDataResult<VisitData>(
        data: _visitData,
      );
    } on ClientException catch (e) {
      return ApiErrorResult<VisitData>(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> attachForm(VisitData visit_data, VisitFormItem form_data) async {
    final _formCreateRequest =
        await PocketbaseHelper.pb.collection(forms_data_collection).create(
              body: form_data.toJson(),
            );

    await PocketbaseHelper.pb.collection(collection).update(
      visit_data.id,
      body: {
        'forms_data_ids+': _formCreateRequest.id,
      },
    );
  }

  Future<void> detachForm(VisitData visit_data, VisitFormItem form_data) async {
    await PocketbaseHelper.pb.collection(forms_data_collection).delete(
          form_data.id,
        );

    await PocketbaseHelper.pb.collection(collection).update(
      visit_data.id,
      body: {
        'forms_data_ids-': form_data.id,
      },
    );
  }

  Future<void> updateFormData(
    VisitData visit_data,
    VisitFormItem form_data,
  ) async {
    await PocketbaseHelper.pb.collection(forms_data_collection).update(
          form_data.id,
          body: form_data.toJson(),
        );
  }

  Future<void> addDrugsToVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper.pb.collection(collection).update(
      visit_data.id,
      body: {
        'drugs_ids+': [...drugs_ids],
      },
    );
  }

  Future<void> removeDrugsFromVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper.pb.collection(collection).update(
      visit_data.id,
      body: {
        'drugs_ids-': [...drugs_ids],
      },
    );
  }

  Future<void> updateDrugsListInVisit(
    VisitData visit_data,
    List<String> drugs_ids,
  ) async {
    await PocketbaseHelper.pb.collection(collection).update(
      visit_data.id,
      body: {
        'drugs_ids': [...drugs_ids],
      },
    );
  }

  Future<void> setDrugDose(
    VisitData visit_data,
    String drug_id,
    String drug_dose,
  ) async {
    await PocketbaseHelper.pb.collection(collection).update(
      visit_data.id,
      body: {
        'drug_data': {
          ...visit_data.drug_data,
          drug_id: drug_dose,
        },
      },
    );
  }

  Future<void> addToItemList(
    VisitData visit_data,
    String item_id,
    ProfileSetupItem setupItem,
  ) async {
    final Map<String, dynamic> _update = switch (setupItem) {
      ProfileSetupItem.drugs => {},
      ProfileSetupItem.labs => {'labs_ids+': item_id},
      ProfileSetupItem.rads => {'rads_ids+': item_id},
      ProfileSetupItem.procedures => {'procedures_ids+': item_id},
      ProfileSetupItem.supplies => {'supplies_ids+': item_id},
    };
    await PocketbaseHelper.pb.collection(collection).update(
          visit_data.id,
          body: _update,
        );
  }

  Future<void> removeFromItemList(
    VisitData visit_data,
    String item_id,
    ProfileSetupItem setupItem,
  ) async {
    final Map<String, dynamic> _update = switch (setupItem) {
      ProfileSetupItem.drugs => {},
      ProfileSetupItem.labs => {'labs_ids-': item_id},
      ProfileSetupItem.rads => {'rads_ids-': item_id},
      ProfileSetupItem.procedures => {'procedures_ids-': item_id},
      ProfileSetupItem.supplies => {'supplies_ids-': item_id},
    };
    await PocketbaseHelper.pb.collection(collection).update(
          visit_data.id,
          body: _update,
        );
  }
}
