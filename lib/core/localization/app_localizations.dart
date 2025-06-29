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

  /// No description provided for @enterValidEnglishNameOfTwoUnits.
  ///
  /// In en, this message translates to:
  /// **'Enter Your First, Middle & Last Names in English'**
  String get enterValidEnglishNameOfTwoUnits;

  /// No description provided for @enterArabicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Name'**
  String get enterArabicName;

  /// No description provided for @enterValidArabicNameOfTwoUnits.
  ///
  /// In en, this message translates to:
  /// **'Enter Your First, Middle & Last Names in Arabic'**
  String get enterValidArabicNameOfTwoUnits;

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

  /// No description provided for @previousPatientVisits.
  ///
  /// In en, this message translates to:
  /// **'Previous Patient Visits'**
  String get previousPatientVisits;

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

  /// No description provided for @myClinics.
  ///
  /// In en, this message translates to:
  /// **'My Clinics'**
  String get myClinics;

  /// No description provided for @mySubscription.
  ///
  /// In en, this message translates to:
  /// **'My Subscriptions'**
  String get mySubscription;

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

  /// No description provided for @errorDialog.
  ///
  /// In en, this message translates to:
  /// **'Error Dialog'**
  String get errorDialog;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'Application Language'**
  String get appLanguage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @logoutPrompt.
  ///
  /// In en, this message translates to:
  /// **'Leaving So Soon ? Are You Sure ?'**
  String get logoutPrompt;

  /// No description provided for @addNewClinic.
  ///
  /// In en, this message translates to:
  /// **'Add New Clinic'**
  String get addNewClinic;

  /// No description provided for @editClinic.
  ///
  /// In en, this message translates to:
  /// **'Update Clinic Info'**
  String get editClinic;

  /// No description provided for @englishClinicName.
  ///
  /// In en, this message translates to:
  /// **'English Clinic Name'**
  String get englishClinicName;

  /// No description provided for @enterEnglishClinicName.
  ///
  /// In en, this message translates to:
  /// **'Enter English Clinic Name'**
  String get enterEnglishClinicName;

  /// No description provided for @arabicClinicName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Clinic Name'**
  String get arabicClinicName;

  /// No description provided for @enterArabicClinicName.
  ///
  /// In en, this message translates to:
  /// **'Enter Arabic Clinic Name'**
  String get enterArabicClinicName;

  /// No description provided for @consultationFees.
  ///
  /// In en, this message translates to:
  /// **'Consultation Fees'**
  String get consultationFees;

  /// No description provided for @enterConsultationFees.
  ///
  /// In en, this message translates to:
  /// **'Enter Consultation Fees'**
  String get enterConsultationFees;

  /// No description provided for @followupFees.
  ///
  /// In en, this message translates to:
  /// **'Followup Fees'**
  String get followupFees;

  /// No description provided for @enterFollowupFees.
  ///
  /// In en, this message translates to:
  /// **'Enter Followup Fees'**
  String get enterFollowupFees;

  /// No description provided for @followupDuration.
  ///
  /// In en, this message translates to:
  /// **'Followup Duration (Days)'**
  String get followupDuration;

  /// No description provided for @enterFollowupDuration.
  ///
  /// In en, this message translates to:
  /// **'Enter Followup Duration In (Days)'**
  String get enterFollowupDuration;

  /// No description provided for @isMain.
  ///
  /// In en, this message translates to:
  /// **'Is Primary Clinic'**
  String get isMain;

  /// No description provided for @noClinicsFound.
  ///
  /// In en, this message translates to:
  /// **'No Clinics Found.'**
  String get noClinicsFound;

  /// No description provided for @toogleClinicActivity.
  ///
  /// In en, this message translates to:
  /// **'Toogle Clinic Activity'**
  String get toogleClinicActivity;

  /// No description provided for @clinicSchedule.
  ///
  /// In en, this message translates to:
  /// **'Clinic Schedule'**
  String get clinicSchedule;

  /// No description provided for @deleteClinic.
  ///
  /// In en, this message translates to:
  /// **'Delete Clinic'**
  String get deleteClinic;

  /// No description provided for @deleteClinicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Deleting This Clinic Will Remove All The Clinic Information And All Visits/Schedules Related To This Clinic In Different Parts Of The Application, This Action Is Irreversible, Are You Sure?'**
  String get deleteClinicPrompt;

  /// No description provided for @deletePrimaryClinicPrompt.
  ///
  /// In en, this message translates to:
  /// **'Confirm Delete Primary Clinic ? Are You Sure ?'**
  String get deletePrimaryClinicPrompt;

  /// No description provided for @clinicDays.
  ///
  /// In en, this message translates to:
  /// **'Clinic Days'**
  String get clinicDays;

  /// No description provided for @dayShifts.
  ///
  /// In en, this message translates to:
  /// **'Day Shifts'**
  String get dayShifts;

  /// No description provided for @addClinicDay.
  ///
  /// In en, this message translates to:
  /// **'Add Clinic Day'**
  String get addClinicDay;

  /// No description provided for @addDayShift.
  ///
  /// In en, this message translates to:
  /// **'Add Day Shift'**
  String get addDayShift;

  /// No description provided for @noScheduleDaysFound.
  ///
  /// In en, this message translates to:
  /// **'No Working Days Were Added To This Clinic.'**
  String get noScheduleDaysFound;

  /// No description provided for @addWorkingWeekday.
  ///
  /// In en, this message translates to:
  /// **'Add Working Day'**
  String get addWorkingWeekday;

  /// No description provided for @shiftStartingTime.
  ///
  /// In en, this message translates to:
  /// **'Shift Starting Time'**
  String get shiftStartingTime;

  /// No description provided for @shiftEndingTime.
  ///
  /// In en, this message translates to:
  /// **'Shift Ending Time'**
  String get shiftEndingTime;

  /// No description provided for @noDayShiftsFound.
  ///
  /// In en, this message translates to:
  /// **'No Shifts Added Yet'**
  String get noDayShiftsFound;

  /// No description provided for @allowedNumberOfVisits.
  ///
  /// In en, this message translates to:
  /// **'Allowed Number Of Visits Per Shift'**
  String get allowedNumberOfVisits;

  /// No description provided for @visitsPerShift.
  ///
  /// In en, this message translates to:
  /// **'Visits Per Shift'**
  String get visitsPerShift;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @deleteShift.
  ///
  /// In en, this message translates to:
  /// **'Delete Shift'**
  String get deleteShift;

  /// No description provided for @deleteSchedule.
  ///
  /// In en, this message translates to:
  /// **'Delete Schedule'**
  String get deleteSchedule;

  /// No description provided for @deleteSchedulePrompt.
  ///
  /// In en, this message translates to:
  /// **'Deleting This Working Clinic Day Will Also Delete it\'s Shifts - This Action Is Irreversible - Are You Sure?'**
  String get deleteSchedulePrompt;

  /// No description provided for @clinicPrescription.
  ///
  /// In en, this message translates to:
  /// **'Clinic Prescription'**
  String get clinicPrescription;

  /// No description provided for @noPrescriptionFileFound.
  ///
  /// In en, this message translates to:
  /// **'No Prescription File Found'**
  String get noPrescriptionFileFound;

  /// No description provided for @addPrescriptionFile.
  ///
  /// In en, this message translates to:
  /// **'Add Prescription File'**
  String get addPrescriptionFile;

  /// No description provided for @deletePrescriptionFile.
  ///
  /// In en, this message translates to:
  /// **'Delete Prescription File'**
  String get deletePrescriptionFile;

  /// No description provided for @prescriptionMenu.
  ///
  /// In en, this message translates to:
  /// **'Prescription Menu'**
  String get prescriptionMenu;

  /// No description provided for @deletePrescriptionFilePrompt.
  ///
  /// In en, this message translates to:
  /// **'Are You Sure About Deleting This Image File - All Prescription Related Settings Will Be Affected - Are You Sure ?'**
  String get deletePrescriptionFilePrompt;

  /// No description provided for @viewPdfPrescription.
  ///
  /// In en, this message translates to:
  /// **'View Pdf Version'**
  String get viewPdfPrescription;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @egp.
  ///
  /// In en, this message translates to:
  /// **'EGP'**
  String get egp;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'Days'**
  String get days;

  /// No description provided for @profileSetup.
  ///
  /// In en, this message translates to:
  /// **'Profile Setup'**
  String get profileSetup;

  /// No description provided for @doctorDrugs.
  ///
  /// In en, this message translates to:
  /// **'Prescription Drugs'**
  String get doctorDrugs;

  /// No description provided for @manage.
  ///
  /// In en, this message translates to:
  /// **'Manage'**
  String get manage;

  /// No description provided for @laboratoryRequests.
  ///
  /// In en, this message translates to:
  /// **'Laboratory Requests'**
  String get laboratoryRequests;

  /// No description provided for @radiology.
  ///
  /// In en, this message translates to:
  /// **'Radiology'**
  String get radiology;

  /// No description provided for @procedures.
  ///
  /// In en, this message translates to:
  /// **'Doctor Procedures'**
  String get procedures;

  /// No description provided for @supplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get supplies;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchByEnglishOrArabicItemName.
  ///
  /// In en, this message translates to:
  /// **'Search By English Or Arabic Item Name'**
  String get searchByEnglishOrArabicItemName;

  /// No description provided for @noItemsFound.
  ///
  /// In en, this message translates to:
  /// **'No Items Found.'**
  String get noItemsFound;

  /// No description provided for @addNewItem.
  ///
  /// In en, this message translates to:
  /// **'Add New Item'**
  String get addNewItem;

  /// No description provided for @updateItem.
  ///
  /// In en, this message translates to:
  /// **'Update Item'**
  String get updateItem;

  /// No description provided for @englishItemName.
  ///
  /// In en, this message translates to:
  /// **'English Item Name'**
  String get englishItemName;

  /// No description provided for @arabicItemName.
  ///
  /// In en, this message translates to:
  /// **'Arabic Item Name'**
  String get arabicItemName;

  /// No description provided for @enter.
  ///
  /// In en, this message translates to:
  /// **'Enter'**
  String get enter;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteItemPrompt.
  ///
  /// In en, this message translates to:
  /// **'Delete This Item From Your Collection, Are You Sure ?'**
  String get deleteItemPrompt;

  /// No description provided for @drugFormAndConcentration.
  ///
  /// In en, this message translates to:
  /// **'Drug Form And Concentration'**
  String get drugFormAndConcentration;

  /// No description provided for @drugDefaultDoses.
  ///
  /// In en, this message translates to:
  /// **'Drug Default Doses'**
  String get drugDefaultDoses;

  /// No description provided for @labSpecialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Lab Special Instructions'**
  String get labSpecialInstructions;

  /// No description provided for @radiologyType.
  ///
  /// In en, this message translates to:
  /// **'Radiology Type'**
  String get radiologyType;

  /// No description provided for @radSpecialInstructions.
  ///
  /// In en, this message translates to:
  /// **'Rad Special Instructions'**
  String get radSpecialInstructions;

  /// No description provided for @supplyItemUnit.
  ///
  /// In en, this message translates to:
  /// **'Supply Item Unit'**
  String get supplyItemUnit;

  /// No description provided for @reorderQuantity.
  ///
  /// In en, this message translates to:
  /// **'Reorder Quantity'**
  String get reorderQuantity;

  /// No description provided for @buyingPrice.
  ///
  /// In en, this message translates to:
  /// **'Buying Price'**
  String get buyingPrice;

  /// No description provided for @sellingPrice.
  ///
  /// In en, this message translates to:
  /// **'Selling Price'**
  String get sellingPrice;

  /// No description provided for @notifyOnReorder.
  ///
  /// In en, this message translates to:
  /// **'Notify On Reorder'**
  String get notifyOnReorder;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @discountPercentage.
  ///
  /// In en, this message translates to:
  /// **'Discount Percentage'**
  String get discountPercentage;

  /// No description provided for @drugConcentration.
  ///
  /// In en, this message translates to:
  /// **'Drug Concentration'**
  String get drugConcentration;

  /// No description provided for @drugForm.
  ///
  /// In en, this message translates to:
  /// **'Drug Form'**
  String get drugForm;

  /// No description provided for @drugUnit.
  ///
  /// In en, this message translates to:
  /// **'Drug Unit'**
  String get drugUnit;

  /// No description provided for @supplyItemUnitEn.
  ///
  /// In en, this message translates to:
  /// **'English Supply Storage Unit'**
  String get supplyItemUnitEn;

  /// No description provided for @supplyItemUnitAr.
  ///
  /// In en, this message translates to:
  /// **'Arabic Supply Storage Unit'**
  String get supplyItemUnitAr;

  /// No description provided for @noSubscriptionsFound.
  ///
  /// In en, this message translates to:
  /// **'No Subscriptions Found'**
  String get noSubscriptionsFound;

  /// No description provided for @currentPlan.
  ///
  /// In en, this message translates to:
  /// **'Current Active Plan'**
  String get currentPlan;

  /// No description provided for @activationDate.
  ///
  /// In en, this message translates to:
  /// **'Activation Date'**
  String get activationDate;

  /// No description provided for @expiryDate.
  ///
  /// In en, this message translates to:
  /// **'Expiry Date'**
  String get expiryDate;

  /// No description provided for @subscriptionStatus.
  ///
  /// In en, this message translates to:
  /// **'Subscription Status'**
  String get subscriptionStatus;

  /// No description provided for @noActiveSubscriptions.
  ///
  /// In en, this message translates to:
  /// **'No Active Subscription'**
  String get noActiveSubscriptions;

  /// No description provided for @purchaseSubscription.
  ///
  /// In en, this message translates to:
  /// **'Purchase Subscription'**
  String get purchaseSubscription;

  /// No description provided for @inGracePeriod.
  ///
  /// In en, this message translates to:
  /// **'In Grace Period'**
  String get inGracePeriod;
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
