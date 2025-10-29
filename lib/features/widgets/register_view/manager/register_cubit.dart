import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? _lastSent; // 🕒 لتتبع آخر مرة اتبعت فيها إيميل

  Future<void> registerUser({
    required String fullName,
    required String email,
    required String password,
    required String phone,
  }) async {
    emit(RegisterLoading());

    try {
      // إنشاء المستخدم
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      final uid = userCredential.user!.uid;

      // إرسال لينك التفعيل أول مرة
      await _safeSendVerificationEmail(userCredential.user);

      // بناء الموديل
      final newUser = UserModel(
        uid: uid,
        fullName: fullName,
        email: email,
        phone: phone,
        createdAt: DateTime.now(),
        role: 'Guest',
        department: null,
        isVerified: false,
      );

      // حفظ في Firestore
      await _firestore.collection('users').doc(uid).set(newUser.toMap());

      emit(RegisterSuccess(newUser));
    } on FirebaseAuthException catch (e) {
      emit(RegisterFailure(_mapFirebaseError(e)));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }

  Future<void> resendVerificationEmail() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await _safeSendVerificationEmail(user);
    }
  }

  /// 🛡️ ميثود آمنة لإرسال الإيميل مع Rate Limiting + Error Handling
  Future<void> _safeSendVerificationEmail(User? user) async {
    if (user == null) return;

    final now = DateTime.now();

    // Check cooldown 30 ثانية
    if (_lastSent != null && now.difference(_lastSent!).inSeconds < 60) {
      emit(RegisterFailure("Please wait 60 seconds before resending."));
      return;
    }

    try {
      await user.sendEmailVerification();
      _lastSent = now;
      emit(RegisterResendVerificationEmail());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'too-many-requests') {
        emit(RegisterFailure("لقد قمت بمحاولات كثيرة. حاول بعد قليل."));
      } else {
        emit(RegisterFailure(_mapFirebaseError(e)));
      }
    } catch (e) {
      emit(RegisterFailure("خطأ غير متوقع: ${e.toString()}"));
    }
  }

  /// 📝 تحويل أكواد FirebaseAuth إلى رسائل أوضح
  String _mapFirebaseError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return "هذا البريد مسجل بالفعل.";
      case 'invalid-email':
        return "البريد الإلكتروني غير صالح.";
      case 'weak-password':
        return "كلمة المرور ضعيفة جداً.";
      case 'operation-not-allowed':
        return "تم تعطيل التسجيل بهذا البريد.";
      default:
        return e.message ?? "خطأ أثناء التسجيل.";
    }
  }
}
