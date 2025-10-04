import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/map_firebase_error.dart';
import '../../register_view/models/user_model.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit() : super(UserDataInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const String cacheKey = "user_cache";
  late UserModel userModel;

  /// Load user data: cache first → then Firestore
  Future<void> loadUserData({required S loc}) async {
    emit(UserDataLoading());

    try {
      final prefs = await SharedPreferences.getInstance();

      final cachedJson = prefs.getString("user_cache");
      if (cachedJson != null) {
        final cachedUser = UserModel.fromMap(jsonDecode(cachedJson));
        userModel = cachedUser;
        emit(UserDataLoadedSuccess(cachedUser));
        return;
      }

      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        emit(UserDataError(loc.unauthenticated));
        return;
      }

      final snapshot =
          await _firestore.collection("users").doc(currentUser.uid).get();

      if (!snapshot.exists) {
        emit(UserDataError(loc.NotFound));
        return;
      }

      final freshUser = UserModel.fromMap(snapshot.data()!);

      await prefs.setString(cacheKey, jsonEncode(freshUser.toMap()));
      userModel = freshUser;
      emit(UserDataLoadedSuccess(freshUser));
    } on FirebaseAuthException catch (e) {
      emit(UserDataError(localizeAuthError(loc: loc, code: e.code)));
    } on FirebaseException catch (e) {
      emit(UserDataError(localizeFirestoreError(loc: loc, code: e.code)));
    } catch (e) {
      emit(UserDataError("${loc.Unknown}: $e"));
    }
  }

  /// Clear cached user data
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(cacheKey);
    emit(UserDataInitial());
  }

  void updateUserData({
    required UserModel currentUser,
    required String fullName,
    required String email,
    required String phone,
    required BuildContext context,
  }) async {
    final loc = S.of(context);
    emit(UserDataLoading());

    try {
      final updatedUser = UserModel(
        uid: currentUser.uid,
        fullName: fullName,
        email: email,
        phone: phone,
        createdAt: currentUser.createdAt,
        role: currentUser.role,
        department: currentUser.department,
        isVerified: currentUser.isVerified,
      );

      // 🔹 Update Firestore
      await _firestore
          .collection("users")
          .doc(currentUser.uid)
          .update(updatedUser.toMap());

      // 🔹 Update SharedPreferences cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(cacheKey, jsonEncode(updatedUser.toMap()));

      // 🔹 Emit updated state
      emit(UserDataUpdatedSuccess(updatedUser: updatedUser));
      loadUserData(loc: loc);
    } on FirebaseAuthException catch (e) {
      emit(UserDataError(localizeAuthError(loc: loc, code: e.code)));
    } on FirebaseException catch (e) {
      emit(UserDataError(localizeFirestoreError(loc: loc, code: e.code)));
    } catch (e) {
      emit(UserDataError("${loc.Unknown}: $e"));
    }
  }
}
