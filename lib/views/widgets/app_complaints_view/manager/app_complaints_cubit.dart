import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/utils/map_firebase_error.dart';

import '../../../../generated/l10n.dart';

part 'app_complaints_state.dart';

class AppComplaintsCubit extends Cubit<AppComplaintsState> {
  AppComplaintsCubit({required this.loc}) : super(ComplaintsInitial());
  final S loc;

  Future<void> submitComplaint({
    required String name,
    required String phone,
    required String message,
  }) async {
    emit(ComplaintsSubmitLoading());

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      emit(ComplaintsSubmitError(error: loc.unauthenticated));
      return;
    }

    try {
      await FirebaseFirestore.instance.collection('complaints').add({
        'userId': user.uid,
        'name': name.trim(),
        'phone': phone.trim(),
        'message': message.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(ComplaintsSubmitSuccess());
    } on FirebaseException catch (e) {
      emit(
        ComplaintsSubmitError(
          error: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } catch (e) {
      emit(ComplaintsSubmitError(error: e.toString()));
    }
  }

  Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    // ✅ Check if ANY active connection exists
    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      emit(ComplaintsNoInternetConnectionState(failure: loc.unavailable));
    }
    return hasConnection;
  }
}
