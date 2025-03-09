import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isFirstTime() async {
  final prefs = await SharedPreferences.getInstance();
  bool? isFirstTime = prefs.getBool('isFirstTime');
  if (isFirstTime == null || isFirstTime) {
    await prefs.setBool('isFirstTime', false); // Set to false after first run
    return true;
  }
  return false;
}
