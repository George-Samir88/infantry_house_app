import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../register_view/models/user_model.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

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
        emit(LoginFailure("User data not found in Firestore"));
        return;
      }

      final user = UserModel.fromMap(snapshot.data()!);

      // 3) Emit success state with user
      emit(LoginSuccess(user));

      // 4) Save only uid to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('uid', uid);
    } on FirebaseAuthException catch (e) {
      emit(LoginFailure(_mapFirebaseAuthError(e)));
    } catch (e) {
      emit(LoginFailure("Unexpected error: ${e.toString()}"));
    }
  }

  // ==============================
  // Helper: Map Firebase Errors
  // ==============================
  String _mapFirebaseAuthError(FirebaseAuthException e) {
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
