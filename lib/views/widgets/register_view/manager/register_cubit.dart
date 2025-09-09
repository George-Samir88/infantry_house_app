import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoading());

    try {
      // Firebase Auth registration
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // Build model
      final newUser = UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
        role: 'Guest',
      );

      // Save to Firestore
      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      emit(RegisterSuccess(newUser));
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailure(e.message ?? "Firebase Auth error"));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
