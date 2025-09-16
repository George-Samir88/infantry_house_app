// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(_current != null,
        'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.');
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(instance != null,
        'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?');
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `دار المشاه`
  String get InfantryHouse {
    return Intl.message(
      'دار المشاه',
      name: 'InfantryHouse',
      desc: '',
      args: [],
    );
  }

  /// `مرحبا بك في دار المشاه`
  String get WelcomeToInfantryHouse {
    return Intl.message(
      'مرحبا بك في دار المشاه',
      name: 'WelcomeToInfantryHouse',
      desc: '',
      args: [],
    );
  }

  /// `ابدأ`
  String get GetStarted {
    return Intl.message(
      'ابدأ',
      name: 'GetStarted',
      desc: '',
      args: [],
    );
  }

  /// `مرحبًا بعودتك!`
  String get WelcomeBack {
    return Intl.message(
      'مرحبًا بعودتك!',
      name: 'WelcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `ليس لديك حساب؟`
  String get DontHaveAnAccount {
    return Intl.message(
      'ليس لديك حساب؟',
      name: 'DontHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `سجل`
  String get Register {
    return Intl.message(
      'سجل',
      name: 'Register',
      desc: '',
      args: [],
    );
  }

  /// `رقم الهاتف`
  String get PhoneNumber {
    return Intl.message(
      'رقم الهاتف',
      name: 'PhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال رقم هاتفك`
  String get PleaseEnterYourPhoneNumber {
    return Intl.message(
      'يرجى إدخال رقم هاتفك',
      name: 'PleaseEnterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `أدخل رقم هاتفك`
  String get EnterYourPhoneNumber {
    return Intl.message(
      'أدخل رقم هاتفك',
      name: 'EnterYourPhoneNumber',
      desc: '',
      args: [],
    );
  }

  /// `البريد الإلكتروني`
  String get Email {
    return Intl.message(
      'البريد الإلكتروني',
      name: 'Email',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال بريدك الإلكتروني`
  String get PleaseEnterYourEmail {
    return Intl.message(
      'يرجى إدخال بريدك الإلكتروني',
      name: 'PleaseEnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `أدخل بريدك الإلكتروني`
  String get EnterYourEmail {
    return Intl.message(
      'أدخل بريدك الإلكتروني',
      name: 'EnterYourEmail',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال بريد إلكتروني صالح`
  String get PleaseEnterAValidEmail {
    return Intl.message(
      'يرجى إدخال بريد إلكتروني صالح',
      name: 'PleaseEnterAValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `كلمة المرور`
  String get Password {
    return Intl.message(
      'كلمة المرور',
      name: 'Password',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال كلمة المرور`
  String get PleaseEnterYourPassword {
    return Intl.message(
      'يرجى إدخال كلمة المرور',
      name: 'PleaseEnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `يجب أن تكون كلمة المرور 6 أحرف على الأقل`
  String get PasswordMustBeAtLeast6CharactersLong {
    return Intl.message(
      'يجب أن تكون كلمة المرور 6 أحرف على الأقل',
      name: 'PasswordMustBeAtLeast6CharactersLong',
      desc: '',
      args: [],
    );
  }

  /// `أدخل كلمة المرور`
  String get EnterYourPassword {
    return Intl.message(
      'أدخل كلمة المرور',
      name: 'EnterYourPassword',
      desc: '',
      args: [],
    );
  }

  /// `هل نسيت كلمة المرور؟`
  String get ForgotPassword {
    return Intl.message(
      'هل نسيت كلمة المرور؟',
      name: 'ForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `تسجيل الدخول`
  String get Login {
    return Intl.message(
      'تسجيل الدخول',
      name: 'Login',
      desc: '',
      args: [],
    );
  }

  /// `أو`
  String get OR {
    return Intl.message(
      'أو',
      name: 'OR',
      desc: '',
      args: [],
    );
  }

  /// `تم تسجيل الدخول بنجاح`
  String get LoggedInSuccessfully {
    return Intl.message(
      'تم تسجيل الدخول بنجاح',
      name: 'LoggedInSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `إنشاء حساب`
  String get CreateAnAccount {
    return Intl.message(
      'إنشاء حساب',
      name: 'CreateAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `لديك حساب بالفعل؟`
  String get AlreadyHaveAnAccount {
    return Intl.message(
      'لديك حساب بالفعل؟',
      name: 'AlreadyHaveAnAccount',
      desc: '',
      args: [],
    );
  }

  /// `اسم المستخدم`
  String get UserName {
    return Intl.message(
      'اسم المستخدم',
      name: 'UserName',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم المستخدم`
  String get EnterYourUserName {
    return Intl.message(
      'أدخل اسم المستخدم',
      name: 'EnterYourUserName',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال اسم المستخدم`
  String get PleaseEnterYourUserName {
    return Intl.message(
      'يرجى إدخال اسم المستخدم',
      name: 'PleaseEnterYourUserName',
      desc: '',
      args: [],
    );
  }

  /// `تم إرسال رمز التحقق`
  String get VerificationCodeSent {
    return Intl.message(
      'تم إرسال رمز التحقق',
      name: 'VerificationCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `لقد أرسلنا لك رمز تحقق مكونًا من 5 أرقام إلى`
  String get WeTextedYouA5DigitCodeTo {
    return Intl.message(
      'لقد أرسلنا لك رمز تحقق مكونًا من 5 أرقام إلى',
      name: 'WeTextedYouA5DigitCodeTo',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخاله أدناه`
  String get PleaseEnterItBelow {
    return Intl.message(
      'يرجى إدخاله أدناه',
      name: 'PleaseEnterItBelow',
      desc: '',
      args: [],
    );
  }

  /// `إعادة الإرسال`
  String get Resend {
    return Intl.message(
      'إعادة الإرسال',
      name: 'Resend',
      desc: '',
      args: [],
    );
  }

  /// `تم التسجيل بنجاح`
  String get RegisteredSuccessfully {
    return Intl.message(
      'تم التسجيل بنجاح',
      name: 'RegisteredSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `تأكيد`
  String get Confirm {
    return Intl.message(
      'تأكيد',
      name: 'Confirm',
      desc: '',
      args: [],
    );
  }

  /// `مرحبًا`
  String get Hello {
    return Intl.message(
      'مرحبًا',
      name: 'Hello',
      desc: '',
      args: [],
    );
  }

  /// `صباح الخير`
  String get GoodMorning {
    return Intl.message(
      'صباح الخير',
      name: 'GoodMorning',
      desc: '',
      args: [],
    );
  }

  /// `قائمة الطعام`
  String get Menu {
    return Intl.message(
      'قائمة الطعام',
      name: 'Menu',
      desc: '',
      args: [],
    );
  }

  /// `اللحوم`
  String get Lo7om {
    return Intl.message(
      'اللحوم',
      name: 'Lo7om',
      desc: '',
      args: [],
    );
  }

  /// `الطيور`
  String get Tyor {
    return Intl.message(
      'الطيور',
      name: 'Tyor',
      desc: '',
      args: [],
    );
  }

  /// `طواجن`
  String get Twagn {
    return Intl.message(
      'طواجن',
      name: 'Twagn',
      desc: '',
      args: [],
    );
  }

  /// `مشويات`
  String get M4wyat {
    return Intl.message(
      'مشويات',
      name: 'M4wyat',
      desc: '',
      args: [],
    );
  }

  /// `فواكه البحر`
  String get FwakhElBa7r {
    return Intl.message(
      'فواكه البحر',
      name: 'FwakhElBa7r',
      desc: '',
      args: [],
    );
  }

  /// `المعجنات`
  String get Mo3gnat {
    return Intl.message(
      'المعجنات',
      name: 'Mo3gnat',
      desc: '',
      args: [],
    );
  }

  /// `المقبلات`
  String get Mokablat {
    return Intl.message(
      'المقبلات',
      name: 'Mokablat',
      desc: '',
      args: [],
    );
  }

  /// `شوربة`
  String get Shorba {
    return Intl.message(
      'شوربة',
      name: 'Shorba',
      desc: '',
      args: [],
    );
  }

  /// `أطباق جانبية`
  String get AtbakGanbya {
    return Intl.message(
      'أطباق جانبية',
      name: 'AtbakGanbya',
      desc: '',
      args: [],
    );
  }

  /// `إفطار`
  String get Eftar {
    return Intl.message(
      'إفطار',
      name: 'Eftar',
      desc: '',
      args: [],
    );
  }

  /// `ركن الاطفال`
  String get RoknElatfal {
    return Intl.message(
      'ركن الاطفال',
      name: 'RoknElatfal',
      desc: '',
      args: [],
    );
  }

  /// `طلبات إضافية للإفطار`
  String get TalabatEdafyaLLftar {
    return Intl.message(
      'طلبات إضافية للإفطار',
      name: 'TalabatEdafyaLLftar',
      desc: '',
      args: [],
    );
  }

  /// `ركن السلطات`
  String get RoknSalatat {
    return Intl.message(
      'ركن السلطات',
      name: 'RoknSalatat',
      desc: '',
      args: [],
    );
  }

  /// `سلطات غربية`
  String get Salatat8rbya {
    return Intl.message(
      'سلطات غربية',
      name: 'Salatat8rbya',
      desc: '',
      args: [],
    );
  }

  /// `ركن السندوتشات`
  String get RoknElsandwichat {
    return Intl.message(
      'ركن السندوتشات',
      name: 'RoknElsandwichat',
      desc: '',
      args: [],
    );
  }

  /// `ركن الحلو`
  String get RoknElhelw {
    return Intl.message(
      'ركن الحلو',
      name: 'RoknElhelw',
      desc: '',
      args: [],
    );
  }

  /// `حجوزات`
  String get hogozat {
    return Intl.message(
      'حجوزات',
      name: 'hogozat',
      desc: '',
      args: [],
    );
  }

  /// `أغذية`
  String get A8zya {
    return Intl.message(
      'أغذية',
      name: 'A8zya',
      desc: '',
      args: [],
    );
  }

  /// `مغسلة`
  String get m8sla {
    return Intl.message(
      'مغسلة',
      name: 'm8sla',
      desc: '',
      args: [],
    );
  }

  /// `أنشطة`
  String get anshta {
    return Intl.message(
      'أنشطة',
      name: 'anshta',
      desc: '',
      args: [],
    );
  }

  /// `إسكان`
  String get eskan {
    return Intl.message(
      'إسكان',
      name: 'eskan',
      desc: '',
      args: [],
    );
  }

  /// `تعديل الإعلانات`
  String get t3delE3lan {
    return Intl.message(
      'تعديل الإعلانات',
      name: 't3delE3lan',
      desc: '',
      args: [],
    );
  }

  /// `تعديل القوائم`
  String get t3delKwaem {
    return Intl.message(
      'تعديل القوائم',
      name: 't3delKwaem',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد إعلانات`
  String get laYogadE3lan {
    return Intl.message(
      'لا يوجد إعلانات',
      name: 'laYogadE3lan',
      desc: '',
      args: [],
    );
  }

  /// `إضافة جديد`
  String get EdaftGded {
    return Intl.message(
      'إضافة جديد',
      name: 'EdaftGded',
      desc: '',
      args: [],
    );
  }

  /// `حفظ`
  String get hefz {
    return Intl.message(
      'حفظ',
      name: 'hefz',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال عنوان القسم باللغة الانجليزية`
  String get MnFdlkD5l3nwanElmenuInEnglish {
    return Intl.message(
      'يرجى إدخال عنوان القسم باللغة الانجليزية',
      name: 'MnFdlkD5l3nwanElmenuInEnglish',
      desc: '',
      args: [],
    );
  }

  /// `يرجى إدخال عنوان القسم باللغة العربية`
  String get MnFdlkD5l3nwanElmenuInArabic {
    return Intl.message(
      'يرجى إدخال عنوان القسم باللغة العربية',
      name: 'MnFdlkD5l3nwanElmenuInArabic',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد أقسام`
  String get LaYogdAksam {
    return Intl.message(
      'لا يوجد أقسام',
      name: 'LaYogdAksam',
      desc: '',
      args: [],
    );
  }

  /// `لا يوجد عناصر`
  String get LaYogd3nasr {
    return Intl.message(
      'لا يوجد عناصر',
      name: 'LaYogd3nasr',
      desc: '',
      args: [],
    );
  }

  /// `تعديل الاصناف`
  String get T3delElasnaf {
    return Intl.message(
      'تعديل الاصناف',
      name: 'T3delElasnaf',
      desc: '',
      args: [],
    );
  }

  /// `إضافة صنف`
  String get EdaftSnf {
    return Intl.message(
      'إضافة صنف',
      name: 'EdaftSnf',
      desc: '',
      args: [],
    );
  }

  /// `إسم الصنف`
  String get EsmElsanf {
    return Intl.message(
      'إسم الصنف',
      name: 'EsmElsanf',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم الصنف`
  String get Ad5lEsmElsnf {
    return Intl.message(
      'أدخل اسم الصنف',
      name: 'Ad5lEsmElsnf',
      desc: '',
      args: [],
    );
  }

  /// `من فضلك أدخل اسم الصنف`
  String get MnFdlkD5lEsmElsnf {
    return Intl.message(
      'من فضلك أدخل اسم الصنف',
      name: 'MnFdlkD5lEsmElsnf',
      desc: '',
      args: [],
    );
  }

  /// `سعر الصنف`
  String get S3rElsnf {
    return Intl.message(
      'سعر الصنف',
      name: 'S3rElsnf',
      desc: '',
      args: [],
    );
  }

  /// `أدخل سعر الصنف`
  String get Ad5lS3rElsnf {
    return Intl.message(
      'أدخل سعر الصنف',
      name: 'Ad5lS3rElsnf',
      desc: '',
      args: [],
    );
  }

  /// `من فضلك أدخل سعر الصنف`
  String get MnFdlkD5lS3rElsnf {
    return Intl.message(
      'من فضلك أدخل سعر الصنف',
      name: 'MnFdlkD5lS3rElsnf',
      desc: '',
      args: [],
    );
  }

  /// `صورة الصنف`
  String get SoraElsnf {
    return Intl.message(
      'صورة الصنف',
      name: 'SoraElsnf',
      desc: '',
      args: [],
    );
  }

  /// `أدخل صورة الصنف`
  String get Ad5lSortElsnf {
    return Intl.message(
      'أدخل صورة الصنف',
      name: 'Ad5lSortElsnf',
      desc: '',
      args: [],
    );
  }

  /// `من فضلك أدخل صورة الصنف`
  String get MnFdlkD5lSortElsnf {
    return Intl.message(
      'من فضلك أدخل صورة الصنف',
      name: 'MnFdlkD5lSortElsnf',
      desc: '',
      args: [],
    );
  }

  /// `تعديل عنصر`
  String get T3del3onsr {
    return Intl.message(
      'تعديل عنصر',
      name: 'T3del3onsr',
      desc: '',
      args: [],
    );
  }

  /// `الأغذیة والمشروبات`
  String get KesmElA8zyaWlma4robat {
    return Intl.message(
      'الأغذیة والمشروبات',
      name: 'KesmElA8zyaWlma4robat',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم القسم بالعربية`
  String get Ad5lEsmElkaemaInArabic {
    return Intl.message(
      'أدخل اسم القسم بالعربية',
      name: 'Ad5lEsmElkaemaInArabic',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم القسم بالانجليزية`
  String get Ad5lEsmElkaemaInEnglish {
    return Intl.message(
      'أدخل اسم القسم بالانجليزية',
      name: 'Ad5lEsmElkaemaInEnglish',
      desc: '',
      args: [],
    );
  }

  /// `قائمة المشروبات`
  String get KaemtElm4areb {
    return Intl.message(
      'قائمة المشروبات',
      name: 'KaemtElm4areb',
      desc: '',
      args: [],
    );
  }

  /// `أعياد الميلاد والمناسبات`
  String get A3yadElmelad {
    return Intl.message(
      'أعياد الميلاد والمناسبات',
      name: 'A3yadElmelad',
      desc: '',
      args: [],
    );
  }

  /// `باراديس`
  String get Paradise {
    return Intl.message(
      'باراديس',
      name: 'Paradise',
      desc: '',
      args: [],
    );
  }

  /// `كافيهات`
  String get Kafehat {
    return Intl.message(
      'كافيهات',
      name: 'Kafehat',
      desc: '',
      args: [],
    );
  }

  /// `تعديل الأقسام`
  String get T3delElaksam {
    return Intl.message(
      'تعديل الأقسام',
      name: 'T3delElaksam',
      desc: '',
      args: [],
    );
  }

  /// `صورة الشيك`
  String get SortElcheck {
    return Intl.message(
      'صورة الشيك',
      name: 'SortElcheck',
      desc: '',
      args: [],
    );
  }

  /// `أدخل صورة الشيك`
  String get Ad5lSortElcheck {
    return Intl.message(
      'أدخل صورة الشيك',
      name: 'Ad5lSortElcheck',
      desc: '',
      args: [],
    );
  }

  /// `من فضلك أدخل صورة الشيك`
  String get MnFdlkD5lSortElcheck {
    return Intl.message(
      'من فضلك أدخل صورة الشيك',
      name: 'MnFdlkD5lSortElcheck',
      desc: '',
      args: [],
    );
  }

  /// `رأيك يهمنا`
  String get Ra2ykYhmna {
    return Intl.message(
      'رأيك يهمنا',
      name: 'Ra2ykYhmna',
      desc: '',
      args: [],
    );
  }

  /// `الكمية قليلة`
  String get FewQuantity {
    return Intl.message(
      'الكمية قليلة',
      name: 'FewQuantity',
      desc: '',
      args: [],
    );
  }

  /// `السعر مرتفع`
  String get HighPrice {
    return Intl.message(
      'السعر مرتفع',
      name: 'HighPrice',
      desc: '',
      args: [],
    );
  }

  /// `وقت التحضير طويل`
  String get PreparationTime {
    return Intl.message(
      'وقت التحضير طويل',
      name: 'PreparationTime',
      desc: '',
      args: [],
    );
  }

  /// `المذاق غير مرضٍ`
  String get Taste {
    return Intl.message(
      'المذاق غير مرضٍ',
      name: 'Taste',
      desc: '',
      args: [],
    );
  }

  /// `أخرى`
  String get Other {
    return Intl.message(
      'أخرى',
      name: 'Other',
      desc: '',
      args: [],
    );
  }

  /// `شارك ملاحظاتك`
  String get ShareYourFeedback {
    return Intl.message(
      'شارك ملاحظاتك',
      name: 'ShareYourFeedback',
      desc: '',
      args: [],
    );
  }

  /// `إرسال`
  String get Submit {
    return Intl.message(
      'إرسال',
      name: 'Submit',
      desc: '',
      args: [],
    );
  }

  /// `يرجى اختيار خيار واحد على الأقل قبل الإرسال`
  String get PleaseSelectAtLeastOneOptionBeforeSubmitting {
    return Intl.message(
      'يرجى اختيار خيار واحد على الأقل قبل الإرسال',
      name: 'PleaseSelectAtLeastOneOptionBeforeSubmitting',
      desc: '',
      args: [],
    );
  }

  /// `أية ملاحظات`
  String get AnyComments {
    return Intl.message(
      'أية ملاحظات',
      name: 'AnyComments',
      desc: '',
      args: [],
    );
  }

  /// `قيم تجربتك`
  String get RateYourExperience {
    return Intl.message(
      'قيم تجربتك',
      name: 'RateYourExperience',
      desc: '',
      args: [],
    );
  }

  /// `ارسال`
  String get Send {
    return Intl.message(
      'ارسال',
      name: 'Send',
      desc: '',
      args: [],
    );
  }

  /// `الشكاوي والاقتراحات`
  String get ComplaintsAndSuggestions {
    return Intl.message(
      'الشكاوي والاقتراحات',
      name: 'ComplaintsAndSuggestions',
      desc: '',
      args: [],
    );
  }

  /// `أدخل ملاحظاتك أو أي اقتراح`
  String get Ad5lMola7zat {
    return Intl.message(
      'أدخل ملاحظاتك أو أي اقتراح',
      name: 'Ad5lMola7zat',
      desc: '',
      args: [],
    );
  }

  /// `السلة`
  String get MyCarts {
    return Intl.message(
      'السلة',
      name: 'MyCarts',
      desc: '',
      args: [],
    );
  }

  /// `السلة فارغة!`
  String get YourCartIsEmpty {
    return Intl.message(
      'السلة فارغة!',
      name: 'YourCartIsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `الإجمالي:`
  String get Total {
    return Intl.message(
      'الإجمالي:',
      name: 'Total',
      desc: '',
      args: [],
    );
  }

  /// `دفع`
  String get Checkout {
    return Intl.message(
      'دفع',
      name: 'Checkout',
      desc: '',
      args: [],
    );
  }

  /// `تراجع`
  String get Undo {
    return Intl.message(
      'تراجع',
      name: 'Undo',
      desc: '',
      args: [],
    );
  }

  /// `تمت إضافة`
  String get AddedSuccessfully {
    return Intl.message(
      'تمت إضافة',
      name: 'AddedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `إلي السلة`
  String get ToCard {
    return Intl.message(
      'إلي السلة',
      name: 'ToCard',
      desc: '',
      args: [],
    );
  }

  /// `تم الحذف بنجاح`
  String get DeletedSuccessfully {
    return Intl.message(
      'تم الحذف بنجاح',
      name: 'DeletedSuccessfully',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم التصنيف`
  String get Ad5lEsmEltsnef {
    return Intl.message(
      'أدخل اسم التصنيف',
      name: 'Ad5lEsmEltsnef',
      desc: '',
      args: [],
    );
  }

  /// `من فضلك أدخل اسم التصنيف`
  String get MnFdlkAd5lEsmEltsnef {
    return Intl.message(
      'من فضلك أدخل اسم التصنيف',
      name: 'MnFdlkAd5lEsmEltsnef',
      desc: '',
      args: [],
    );
  }

  /// `ألعاب يومية`
  String get DailyGames {
    return Intl.message(
      'ألعاب يومية',
      name: 'DailyGames',
      desc: '',
      args: [],
    );
  }

  /// `الإشتراكات`
  String get Subscriptions {
    return Intl.message(
      'الإشتراكات',
      name: 'Subscriptions',
      desc: '',
      args: [],
    );
  }

  /// `أسم المدرب`
  String get TrainerName {
    return Intl.message(
      'أسم المدرب',
      name: 'TrainerName',
      desc: '',
      args: [],
    );
  }

  /// `صورة اللعبة`
  String get DailyGamesItemImage {
    return Intl.message(
      'صورة اللعبة',
      name: 'DailyGamesItemImage',
      desc: '',
      args: [],
    );
  }

  /// `أضف صورة اللعبة`
  String get AddDailyGamesItemImage {
    return Intl.message(
      'أضف صورة اللعبة',
      name: 'AddDailyGamesItemImage',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إضافة صورة اللعبة`
  String get PleaseAddDailyGamesItemImage {
    return Intl.message(
      'الرجاء إضافة صورة اللعبة',
      name: 'PleaseAddDailyGamesItemImage',
      desc: '',
      args: [],
    );
  }

  /// `أسم اللعبة`
  String get TitleOfGame {
    return Intl.message(
      'أسم اللعبة',
      name: 'TitleOfGame',
      desc: '',
      args: [],
    );
  }

  /// `أدخل أسم اللعبة`
  String get EnterTitleOfGame {
    return Intl.message(
      'أدخل أسم اللعبة',
      name: 'EnterTitleOfGame',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال أسم اللعبة`
  String get PleaseEnterTitleOfGame {
    return Intl.message(
      'الرجاء إدخال أسم اللعبة',
      name: 'PleaseEnterTitleOfGame',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم المدرب`
  String get EnterTrainerName {
    return Intl.message(
      'أدخل اسم المدرب',
      name: 'EnterTrainerName',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال اسم المدرب`
  String get PleaseEnterTrainerName {
    return Intl.message(
      'الرجاء إدخال اسم المدرب',
      name: 'PleaseEnterTrainerName',
      desc: '',
      args: [],
    );
  }

  /// `سعر اللعبة`
  String get GamePrice {
    return Intl.message(
      'سعر اللعبة',
      name: 'GamePrice',
      desc: '',
      args: [],
    );
  }

  /// `أدخل سعر اللعبة`
  String get EnterPriceOfGame {
    return Intl.message(
      'أدخل سعر اللعبة',
      name: 'EnterPriceOfGame',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إدخال سعر اللعبة`
  String get PleaseEnterPriceOfGame {
    return Intl.message(
      'الرجاء إدخال سعر اللعبة',
      name: 'PleaseEnterPriceOfGame',
      desc: '',
      args: [],
    );
  }

  /// `وصف عن اللعبة`
  String get DescriptionAboutGame {
    return Intl.message(
      'وصف عن اللعبة',
      name: 'DescriptionAboutGame',
      desc: '',
      args: [],
    );
  }

  /// `أضف وصفاً عن اللعبة`
  String get EnterDescriptionAboutGame {
    return Intl.message(
      'أضف وصفاً عن اللعبة',
      name: 'EnterDescriptionAboutGame',
      desc: '',
      args: [],
    );
  }

  /// `الرجاء إضافة وصف عن اللعبة`
  String get PleaseEnterDescriptionAboutGame {
    return Intl.message(
      'الرجاء إضافة وصف عن اللعبة',
      name: 'PleaseEnterDescriptionAboutGame',
      desc: '',
      args: [],
    );
  }

  /// `إضافة لعبة جديدة`
  String get AddingNewDailyGame {
    return Intl.message(
      'إضافة لعبة جديدة',
      name: 'AddingNewDailyGame',
      desc: '',
      args: [],
    );
  }

  /// `تعديل اللعبة`
  String get UpdateDailyGame {
    return Intl.message(
      'تعديل اللعبة',
      name: 'UpdateDailyGame',
      desc: '',
      args: [],
    );
  }

  /// `حذف`
  String get Delete {
    return Intl.message(
      'حذف',
      name: 'Delete',
      desc: '',
      args: [],
    );
  }

  /// `القسم موجود بالفعل! لا يمكنك إضافة قسم جديد بنفس الاسم.`
  String get TheSectionAlreadyExistsYouCannotAddANewSectionWithTheSameName {
    return Intl.message(
      'القسم موجود بالفعل! لا يمكنك إضافة قسم جديد بنفس الاسم.',
      name: 'TheSectionAlreadyExistsYouCannotAddANewSectionWithTheSameName',
      desc: '',
      args: [],
    );
  }

  /// `يجب إضافة قسم رئيسي أولاً.`
  String get PleaseAddAMainCategoryFirst {
    return Intl.message(
      'يجب إضافة قسم رئيسي أولاً.',
      name: 'PleaseAddAMainCategoryFirst',
      desc: '',
      args: [],
    );
  }

  /// `تعديل اسم التصنيف`
  String get UpdateTitle {
    return Intl.message(
      'تعديل اسم التصنيف',
      name: 'UpdateTitle',
      desc: '',
      args: [],
    );
  }

  /// `أدخل اسم التصنيف`
  String get TypeTitle {
    return Intl.message(
      'أدخل اسم التصنيف',
      name: 'TypeTitle',
      desc: '',
      args: [],
    );
  }

  /// `إلغاء`
  String get Cancel {
    return Intl.message(
      'إلغاء',
      name: 'Cancel',
      desc: '',
      args: [],
    );
  }

  /// `لا يمكن أن يكون الحقل فارغًا`
  String get FieldCannotBeEmpty {
    return Intl.message(
      'لا يمكن أن يكون الحقل فارغًا',
      name: 'FieldCannotBeEmpty',
      desc: '',
      args: [],
    );
  }

  /// `حدث خطأ!`
  String get ErrorOccurred {
    return Intl.message(
      'حدث خطأ!',
      name: 'ErrorOccurred',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
