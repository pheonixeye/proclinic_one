import 'package:proklinik_one/core/api/handler/api_result.dart';
import 'package:proklinik_one/models/patient.dart';
import 'package:proklinik_one/models/pc_form.dart';

typedef PatientDataResult = ApiDataResult<List<Patient>>;

typedef FormDataResult = ApiDataResult<List<PcForm>>;
