import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../generated/l10n.dart';
import '../../register_view/models/user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit({required this.loc}) : super(LoginInitial());
  final S loc;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      // 1) Sign in with Firebase Auth
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user!.uid;

      // 2) Fetch user data from Firestore
      final snapshot = await firestore.collection('users').doc(uid).get();
      if (!snapshot.exists) {
        emit(LoginFailure(loc.NotFound));
        return;
      }

      // 3) Check if user is verified
      User? currentUser = userCredential.user;
      if (currentUser != null) {
        await currentUser.reload(); // تحديث حالة الحساب
        currentUser = auth.currentUser;

        if (currentUser!.emailVerified) {
          // ✅ مفعّل
          await firestore.collection("users").doc(currentUser.uid).update({
            "isVerified": true,
          });
          final user = UserModel.fromMap(snapshot.data()!);

          // 4) Emit success state with user
          emit(LoginSuccess(user));

          // 5) Save only uid to SharedPreferences
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('uid', uid);
        } else {
          // ⚠️ مش مفعّل
          emit(LoginFailure(_mapFirebaseAuthError(null, emailVerified: false)));
          // هنا تقدر تمنعه من الدخول وتدي Alert
        }
      }
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_mapFirebaseAuthError(e)));
    } catch (e) {
      emit(LoginFailure("Unexpected error: ${e.toString()}"));
    }
  }

  // ==============================
  // Reset Password Function
  // ==============================
  Future<void> resetPassword({required String email}) async {
    emit(ResetPasswordLoading()); // نفس حالة الـ loading بتاعة اللوجين

    try {
      await auth.sendPasswordResetEmail(email: email.trim());

      emit(ResetPasswordSuccess());
    } on FirebaseAuthException catch (e) {
      emit(ResetPasswordFailure(error: _mapFirebaseAuthError(e)));
    } catch (e) {
      emit(ResetPasswordFailure(error: e.toString()));
    }
  }

  // ==============================
  // Helper: Map Firebase Errors
  // ==============================
  String _mapFirebaseAuthError(
    FirebaseAuthException? e, {
    bool emailVerified = true,
  }) {
    if (!emailVerified) {
      return "Please verify your email address before logging in.";
    }

    if (e == null) {
      return "Authentication error occurred.";
    }

    switch (e.code) {
      case "invalid-email":
        return "The email address is not valid.";
      case "user-disabled":
        return "This account has been disabled.";
      case "user-not-found":
        return "No account found with this email.";
      case "wrong-password":
        return "Incorrect password.";
      case "network-request-failed":
        return "No internet connection.";
      default:
        return e.message ?? "Authentication error occurred.";
    }
  }
}
