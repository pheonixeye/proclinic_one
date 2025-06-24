// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

enum AppErrorCode {
  clientException(1),
  authException(2);

  final int code;

  const AppErrorCode(this.code);
}

class TranslatedError extends Equatable {
  final String en;
  final String ar;

  const TranslatedError({
    required this.en,
    required this.ar,
  });

  @override
  List<Object> get props => [en, ar];
}

class CodeToError {
  const CodeToError(this.code);

  final int code;

  static Map<int, TranslatedError> errors = {
    //client_exception_code
    AppErrorCode.clientException.code: TranslatedError(
      en: 'Something Went Wrong While Fetching Data.',
      ar: 'حدث خطا اثناء تنزيل البيانات المطلوبة',
    ),
    //authentication_exception_code
    AppErrorCode.authException.code: TranslatedError(
      en: 'Something Went Wrong While Authenticating, check Email / Password combination.',
      ar: 'حدث خطا اثناء تسجبل الدخول - برجاء مراجعة البريد الالكتروني و كلمة السر.',
    ),
  };

  String errorMessage(bool isEnglish) =>
      isEnglish ? errors[code]!.en : errors[code]!.ar;
}
