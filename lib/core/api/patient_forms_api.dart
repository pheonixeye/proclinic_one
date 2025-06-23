import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/core/api/handler/api_result.dart';
import 'package:proklinik_one/errors/code_to_error.dart';
import 'package:proklinik_one/models/patient_form_field_data.dart';
import 'package:proklinik_one/models/patient_form_item.dart';

class PatientFormsApi {
  final String doc_id;
  final String patient_id;

  PatientFormsApi({
    required this.doc_id,
    required this.patient_id,
  }) {
    _checkIfCollectionExists();
  }

  late final String collection = '${doc_id}__patient__formdata';

  Future<void> _checkIfCollectionExists() async {
    //TODO
  }

  Future<ApiResult<List<PatientFormItem>>> fetchPatientForms() async {
    try {
      final _response =
          await PocketbaseHelper.pb.collection(collection).getList(
                filter: "patient_id = '$patient_id'",
                sort: '-created',
              );

      final _patientFormData = _response.items
          .map((e) => PatientFormItem.fromJson(e.toJson()))
          .toList();

      // dprint(_patientFormData);

      return ApiDataResult<List<PatientFormItem>>(data: _patientFormData);
    } on ClientException catch (e) {
      return ApiErrorResult(
        errorCode: AppErrorCode.clientException.code,
        originalErrorMessage: e.toString(),
      );
    }
  }

  Future<void> attachFormToPatient(PatientFormItem formItem) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: formItem.toJson(),
        );
  }

  Future<void> detachFormFromPatient(PatientFormItem formItem) async {
    await PocketbaseHelper.pb.collection(collection).delete(
          formItem.id,
        );
  }

  Future<void> updatePatientFormFieldData(
    PatientFormItem formItem,
    PatientFormFieldData formData,
  ) async {
    final _newData = formItem.form_data
      ..removeWhere((e) => e.id == formData.id)
      ..add(formData);

    await PocketbaseHelper.pb.collection(collection).update(
      formItem.id,
      body: {
        'form_data': _newData.map((e) => e.toJson()).toList(),
      },
    );
  }
}
