import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/patient.dart';

class PatientsApi {
  PatientsApi({required this.doc_id}) {
    _checkIfCollectionExists();
  }

  final String doc_id;

  late final String collection = '${doc_id}__patients';

  Future<void> _checkIfCollectionExists() async {
    //TODO:
  }

  Future<List<Patient>> fetchPatients({
    required int page,
    required int perPage,
  }) async {
    final _response = await PocketbaseHelper.pb.collection(collection).getList(
          page: page,
          perPage: perPage,
          sort: '-created',
        );

    final patients =
        _response.items.map((e) => Patient.fromJson(e.toJson())).toList();

    return patients;
  }

  Future<void> createPatientProfile(Patient patient) async {
    await PocketbaseHelper.pb.collection(collection).create(
          body: patient.toJson(),
        );
  }
}
