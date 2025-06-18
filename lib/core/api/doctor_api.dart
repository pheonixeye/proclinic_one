import 'package:pocketbase/pocketbase.dart';
import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/doctor.dart';

class DoctorApi {
  const DoctorApi({required this.doc_id});

  final String doc_id;

  static const String collection = 'doctors';

  static const String expand = 'speciality_id';

  Future<Doctor> fetchDoctorProfile() async {
    final _response = await PocketbaseHelper.pb.collection(collection).getOne(
          doc_id,
          expand: expand,
        );

    final doctor = Doctor.fromJson({
      ..._response.toJson(),
      'speciality': _response.get<RecordModel>('expand.speciality_id').toJson()
    });

    return doctor;
  }
}
