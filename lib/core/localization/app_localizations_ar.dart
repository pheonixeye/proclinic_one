import 'app_localizations.dart';

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get homepage => 'الصفحة الرئيسية';

  @override
  String get somethingWentWrong => 'حدث خطأ اثناء البحث';

  @override
  String get errorText => 'يبدو أن هذه الصفحة قد تم نقلها أو أنها غير متوفرة في الوقت الحالي، يرجى المحاولة مرة أخرى لاحقًا.';

  @override
  String get loading => 'جارى التحميل ...';

  @override
  String get todayVisits => 'زيارات اليوم';
}
