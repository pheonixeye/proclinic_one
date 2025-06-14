import 'package:proklinik_one/core/api/constants/pocketbase_helper.dart';
import 'package:proklinik_one/models/speciality.dart';

extension Imageurl on Speciality {
  String get imageUrl =>
      '${PocketbaseHelper.pb.baseURL}/api/files/specialities/$id/$image';
}
