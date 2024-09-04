import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get homepage => 'HomePage';

  @override
  String get somethingWentWrong => 'Something Went Wrong';

  @override
  String get errorText => 'This Page Seems To Be Moved Or Not Available At The Moment, Kindly Try Again Later.';

  @override
  String get loading => 'Loading...';

  @override
  String get todayVisits => 'Today\'s Visits';
}
