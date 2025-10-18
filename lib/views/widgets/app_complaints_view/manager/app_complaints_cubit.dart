import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infantry_house_app/utils/map_firebase_error.dart';
import 'package:infantry_house_app/views/widgets/app_complaints_view/models/app_complaints_model.dart';

import '../../../../generated/l10n.dart';

part 'app_complaints_state.dart';

class AppComplaintsCubit extends Cubit<AppComplaintsState> {
  AppComplaintsCubit({required this.loc}) : super(ComplaintsInitial());
  final S loc;
  List<AppComplaintsModel> complaintsList = [];
  FirebaseFirestore firestore = FirebaseFirestore.instance;

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

    // 🧹 Sanitize inputs
    final trimmedName = name.trim().isEmpty ? "Anonymous" : name.trim();
    final trimmedPhone = phone.trim();
    final trimmedMessage = message.trim();

    if (trimmedPhone.isEmpty || trimmedMessage.isEmpty) {
      emit(ComplaintsSubmitError(error: loc.FieldCannotBeEmpty));
      return;
    }

    try {
      // 🧾 Build Firestore data directly (to use server timestamp)
      await firestore.collection('complaints').add({
        'userId': user.uid,
        'name': trimmedName,
        'phone': trimmedPhone,
        'message': trimmedMessage,
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

  Future<void> getComplaints() async {
    if (!await hasInternetConnection()) {
      return;
    }
    emit(ComplaintsGetLoading());

    try {
      final snapshot =
          await firestore
              .collection('complaints')
              .orderBy('timestamp', descending: true)
              .get();

      if (snapshot.docs.isEmpty) {
        complaintsList = [];
        emit(ComplaintsGetEmpty());
        return;
      }

      // ✅ Convert Firestore documents into strongly-typed models
      complaintsList =
          snapshot.docs.map((doc) {
            return AppComplaintsModel.fromDoc(doc.data(), doc.id);
          }).toList();

      emit(ComplaintsGetSuccess());
    } on FirebaseException catch (e) {
      emit(
        ComplaintsGetFailure(
          failure: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } catch (e) {
      emit(ComplaintsGetFailure(failure: e.toString()));
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
