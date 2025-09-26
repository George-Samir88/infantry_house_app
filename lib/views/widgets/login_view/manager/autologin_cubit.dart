import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../register_view/models/user_model.dart';

part 'autologin_state.dart';

class AutoLoginCubit extends Cubit<AutoLoginState> {
  AutoLoginCubit() : super(AutoLoginInitial());

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Try auto login with full scenario handling
  Future<void> tryAutoLogin() async {
    emit(AutoLoginLoading());

    try {
      final prefs = await SharedPreferences.getInstance();
      final uid = prefs.getString('uid');

      // --------------------
      // Case 1: No UID stored
      // --------------------
      if (uid == null) {
        emit(AutoLoginInitial());
        return;
      }

      // --------------------
      // Load cached UserModel (if any)
      // --------------------
      final cachedJson = prefs.getString('user_cache');
      UserModel? cachedUser;
      if (cachedJson != null) {
        cachedUser = UserModel.fromMap(jsonDecode(cachedJson));
      }

      // --------------------
      // Reload current Firebase user
      // --------------------
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        await currentUser.reload();
        currentUser = _auth.currentUser;
      }

      // --------------------
      // Check Firestore user data
      // --------------------
      final snap = await _firestore.collection("users").doc(uid).get();

      if (snap.exists) {
        final freshUser = UserModel.fromMap(snap.data()!);

        // --------------------
        // Check email verification
        // --------------------
        if (currentUser != null && !currentUser.emailVerified) {
          emit(AutoLoginEmailNotVerified("Please verify your email address."));
          return;
        }

        // If verified but Firestore not updated → update it
        if (currentUser != null &&
            currentUser.emailVerified &&
            !freshUser.isVerified) {
          await _firestore.collection("users").doc(uid).update({
            "isVerified": true,
          });
          freshUser.isVerified = true;
        }

        // Update cache if changed
        if (cachedUser == null ||
            jsonEncode(freshUser.toMap()) != jsonEncode(cachedUser.toMap())) {
          await prefs.setString('user_cache', jsonEncode(freshUser.toMap()));
        }

        // ✅ Emit fresh user
        emit(AutoLoginSuccess(freshUser));
      } else {
        // UID not valid in Firestore → clear session
        await logout();
        emit(AutoLoginUserNotFound("User not found in Firestore"));
      }
    } catch (e) {
      // --------------------
      // Handle errors (no internet, timeout, etc.)
      // --------------------
      final prefs = await SharedPreferences.getInstance();
      final cachedJson = prefs.getString('user_cache');

      if (cachedJson != null) {
        final cachedUser = UserModel.fromMap(jsonDecode(cachedJson));
        // ✅ Emit cached only once as fallback
        emit(AutoLoginSuccess(cachedUser));
      } else {
        emit(AutoLoginFailure("Login failed: $e"));
      }
    }
  }

  /// Save session: only store uid + cache latest user
  Future<void> saveUserSession(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('user_cache', jsonEncode(user.toMap()));
  }

  Future<void> logout() async {
    await _auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('uid');
    await prefs.remove('user_cache');
    emit(AutoLoginInitial());
  }

  Future<void> saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('uid', user.uid);
    await prefs.setString('email', user.email);
    await prefs.setString('fullName', user.fullName);
    await prefs.setString('role', user.role);
  }
}
