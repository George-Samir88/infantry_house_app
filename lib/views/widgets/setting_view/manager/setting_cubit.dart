import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../global_variables.dart';
import '../../../../main.dart';

part 'setting_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingInitialState());
  bool darkMode = false;
  bool notificationsEnabled = true;
  String selectedLanguage = 'ar';

  static SettingsCubit get(context) => BlocProvider.of(context);

  // Load all settings (dark mode, notifications, language)
  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();

    darkMode = prefs.getBool('darkMode') ?? false;
    notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    selectedLanguage = prefs.getString('locale') ?? 'ar';
    emit(SettingLoadAllSettingState());
  }

  // 🌗 Toggle Dark Mode
  Future<void> toggleDarkMode() async {
    final newValue = !darkMode;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('darkMode', newValue);

    emit(SettingToggleModeState());
  }

  // 🔔 Toggle Notifications
  Future<void> toggleNotifications() async {
    final newValue = !notificationsEnabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', newValue);

    emit(SettingToggleNotificationState());
  }

  // 🌐 Change Language
  Future<void> changeLanguage({required String code, context}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', code);
    InfantryHouseApp.setLocale(context, Locale(code));
    selectedLanguage = code;
    GlobalData().isArabic = selectedLanguage == 'ar';
    emit(SettingToggleLanguageState());
  }
}
