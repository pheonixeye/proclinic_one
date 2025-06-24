import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en')
  ];

  /// No description provided for @homepage.
  ///
  /// In en, this message translates to:
  /// **'HomePage'**
  String get homepage;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something Went Wrong'**
  String get somethingWentWrong;

  /// No description provided for @errorText.
  ///
  /// In en, this message translates to:
  /// **'This Page Seems To Be Moved Or Not Available At The Moment, Kindly Try Again Later.'**
  String get errorText;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @todayVisits.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Visits'**
  String get todayVisits;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get register;

  /// No description provided for @heroTitle.
  ///
  /// In en, this message translates to:
  /// **'A Doctor\'s Second Brain and Companion.'**
  String get heroTitle;

  /// No description provided for @heroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ProKliniK HealthCare CRM is a Powerful Tool to Manage Your Workday and Keep in Touch With Your Patients.'**
  String get heroSubtitle;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @loginTag.
  ///
  /// In en, this message translates to:
  /// **'Connect with Your Patients, Simplify Your Schedule, and Grow Your Practice.'**
  String get loginTag;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password ?'**
  String get forgotPassword;

  /// No description provided for @notRegisteredYet.
  ///
  /// In en, this message translates to:
  /// **'Not Registered Yet ?'**
  String get notRegisteredYet;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create An Account'**
  String get createAccount;

  /// No description provided for @enterEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Enter Email Address'**
  String get enterEmailAddress;

  /// No description provided for @enterPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter Password'**
  String get enterPassword;

  /// No description provided for @invalidEmailAddress.
  ///
  /// In en, this message translates to:
  /// **'Invalid Email Address'**
  String get invalidEmailAddress;

  /// No description provided for @registerTag.
  ///
  /// In en, this message translates to:
  /// **'Join ProKliniK Today and Empower Your Practice with Better Patient Care and Meaningful Growth.'**
  String get registerTag;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @enterConfirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get enterConfirmPassword;

  /// No description provided for @speciality.
  ///
  /// In en, this message translates to:
  /// **'Speciality'**
  String get speciality;

  /// No description provided for @selectSpeciality.
  ///
  /// In en, this message translates to:
  /// **'Select Speciality'**
  String get selectSpeciality;

  /// No description provided for @alreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'Already Registered ?'**
  String get alreadyRegistered;

  /// No description provided for @passwordsNotMatching.
  ///
  /// In en, this message translates to:
  /// **'Password Not Matching.'**
  String get passwordsNotMatching;

  /// No description provided for @passwordEightLetters.
  ///
  /// In en, this message translates to:
  /// **'Password Length Should Be Longer Than 8 Characters.'**
  String get passwordEightLetters;

  /// No description provided for @allRightsReserved.
  ///
  /// In en, this message translates to:
  /// **'All Rights Reserved @Proklinik Medical Software'**
  String get allRightsReserved;

  /// No description provided for @professionalMessage.
  ///
  /// In en, this message translates to:
  /// **'We look forward to helping you easily manage your healthcare appointments. If you have any feedback on how we can improve, feel free to share it with us. We value your input as we continuously work to enhance our platform.'**
  String get professionalMessage;

  /// No description provided for @verificationEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A Verification Message Was Sent To Your Email Address.'**
  String get verificationEmailSent;

  /// No description provided for @thankyouForRegistering.
  ///
  /// In en, this message translates to:
  /// **'Welcome to ProKliniK! We’re excited to have you on board.'**
  String get thankyouForRegistering;

  /// No description provided for @passwordResetEmailSent.
  ///
  /// In en, this message translates to:
  /// **'A Password Reset Message Was Sent To Your Email Address.'**
  String get passwordResetEmailSent;

  /// No description provided for @englishName.
  ///
  /// In en, this message translates to:
  /// **'English Name'**
  String get englishName;

  /// No description provided for @arabicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Name'**
  String get arabicName;

  /// No description provided for @enterEnglishName.
  ///
  /// In en, this message translates to:
  /// **'Enter English Name'**
  String get enterEnglishName;

  /// No description provided for @enterArabicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Name'**
  String get enterArabicName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get phone;

  /// No description provided for @enterPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter Mobile Number'**
  String get enterPhoneNumber;

  /// No description provided for @enterValidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Mobile Number - 11 Digits.'**
  String get enterValidPhoneNumber;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @myPatients.
  ///
  /// In en, this message translates to:
  /// **'My Patients'**
  String get myPatients;

  /// No description provided for @noPatientsFound.
  ///
  /// In en, this message translates to:
  /// **'No Patients Found.'**
  String get noPatientsFound;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @previous.
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previous;

  /// No description provided for @addNewPatient.
  ///
  /// In en, this message translates to:
  /// **'Add New Patient'**
  String get addNewPatient;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @enterPatientName.
  ///
  /// In en, this message translates to:
  /// **'Enter Patient Name'**
  String get enterPatientName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @enterPatientPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter Patient Mobile Number'**
  String get enterPatientPhone;

  /// No description provided for @enterValidPatientPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a Valid Patient Mobile Number - 11 digits'**
  String get enterValidPatientPhone;

  /// No description provided for @dateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dateOfBirth;

  /// No description provided for @selectPatientDateOfBirth.
  ///
  /// In en, this message translates to:
  /// **'Select Patient Date Of Birth'**
  String get selectPatientDateOfBirth;

  /// No description provided for @searchByPatientNameorMobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Search By Patient Name or Mobile Number'**
  String get searchByPatientNameorMobileNumber;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @findPatient.
  ///
  /// In en, this message translates to:
  /// **'Find Patient'**
  String get findPatient;

  /// No description provided for @clearSearch.
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// No description provided for @editPatientData.
  ///
  /// In en, this message translates to:
  /// **'Edit Patient Data'**
  String get editPatientData;

  /// No description provided for @patientActions.
  ///
  /// In en, this message translates to:
  /// **'Patient Actions'**
  String get patientActions;

  /// No description provided for @quickVisit.
  ///
  /// In en, this message translates to:
  /// **'Quick Visit'**
  String get quickVisit;

  /// No description provided for @addNewVisit.
  ///
  /// In en, this message translates to:
  /// **'Add New Visit'**
  String get addNewVisit;

  /// No description provided for @scheduleAppointment.
  ///
  /// In en, this message translates to:
  /// **'Schedule Appointment'**
  String get scheduleAppointment;

  /// No description provided for @attachForm.
  ///
  /// In en, this message translates to:
  /// **'Attach Form'**
  String get attachForm;

  /// No description provided for @editFormData.
  ///
  /// In en, this message translates to:
  /// **'Edit Form Data'**
  String get editFormData;

  /// No description provided for @detachForm.
  ///
  /// In en, this message translates to:
  /// **'Detach Form'**
  String get detachForm;

  /// No description provided for @patientForms.
  ///
  /// In en, this message translates to:
  /// **'Patient Forms'**
  String get patientForms;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @visits.
  ///
  /// In en, this message translates to:
  /// **'Visits'**
  String get visits;

  /// No description provided for @organizer.
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// No description provided for @forms.
  ///
  /// In en, this message translates to:
  /// **'Forms'**
  String get forms;

  /// No description provided for @bookkeeping.
  ///
  /// In en, this message translates to:
  /// **'Bookkeeping'**
  String get bookkeeping;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @addNewForm.
  ///
  /// In en, this message translates to:
  /// **'Add New Form'**
  String get addNewForm;

  /// No description provided for @editForm.
  ///
  /// In en, this message translates to:
  /// **'Edit Form'**
  String get editForm;

  /// No description provided for @englishFormName.
  ///
  /// In en, this message translates to:
  /// **'English Form Name'**
  String get englishFormName;

  /// No description provided for @arabicFormName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Form Name'**
  String get arabicFormName;

  /// No description provided for @enterEnglishFormName.
  ///
  /// In en, this message translates to:
  /// **'Enter English Form Name'**
  String get enterEnglishFormName;

  /// No description provided for @enterArabicFormName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Form Name'**
  String get enterArabicFormName;

  /// No description provided for @noFormsFound.
  ///
  /// In en, this message translates to:
  /// **'No Forms Found'**
  String get noFormsFound;

  /// No description provided for @addNewField.
  ///
  /// In en, this message translates to:
  /// **'Add New Field'**
  String get addNewField;

  /// No description provided for @deleteForm.
  ///
  /// In en, this message translates to:
  /// **'Delete Form'**
  String get deleteForm;

  /// No description provided for @formFields.
  ///
  /// In en, this message translates to:
  /// **'Form Fields'**
  String get formFields;

  /// No description provided for @fieldValues.
  ///
  /// In en, this message translates to:
  /// **'Field Values'**
  String get fieldValues;

  /// No description provided for @commaSeparatedValues.
  ///
  /// In en, this message translates to:
  /// **'Separate Values by a (-) sign'**
  String get commaSeparatedValues;

  /// No description provided for @editFieldName.
  ///
  /// In en, this message translates to:
  /// **'Edit Field Name'**
  String get editFieldName;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Field Name'**
  String get fieldName;

  /// No description provided for @fieldType.
  ///
  /// In en, this message translates to:
  /// **'Field Type'**
  String get fieldType;

  /// No description provided for @fieldNameHint.
  ///
  /// In en, this message translates to:
  /// **'Try Making The Field Name Remarkable'**
  String get fieldNameHint;

  /// No description provided for @enterFieldName.
  ///
  /// In en, this message translates to:
  /// **'Enter Field Name'**
  String get enterFieldName;

  /// No description provided for @promptDialog.
  ///
  /// In en, this message translates to:
  /// **'Prompt Dialog'**
  String get promptDialog;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @deleteFormField.
  ///
  /// In en, this message translates to:
  /// **'Delete Form Field'**
  String get deleteFormField;

  /// No description provided for @editFormFieldName.
  ///
  /// In en, this message translates to:
  /// **'Edit Form Field Name'**
  String get editFormFieldName;

  /// No description provided for @confirmDeleteForm.
  ///
  /// In en, this message translates to:
  /// **'This Action Will Delete This Form And All Data Related To It\'s Entries, Are You Sure ?'**
  String get confirmDeleteForm;

  /// No description provided for @confirmDeleteFormField.
  ///
  /// In en, this message translates to:
  /// **'This Action Will Delete This Field From This Form And All Data Related To It\'s Entries, This Action Is Irreversible, Are You Sure ?'**
  String get confirmDeleteFormField;

  /// No description provided for @fillForm.
  ///
  /// In en, this message translates to:
  /// **'Fill Form'**
  String get fillForm;

  /// No description provided for @noFormIsSelected.
  ///
  /// In en, this message translates to:
  /// **'No Form Is Selected.'**
  String get noFormIsSelected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
