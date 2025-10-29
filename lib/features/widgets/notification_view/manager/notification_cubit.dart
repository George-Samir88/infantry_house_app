import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../generated/l10n.dart';
import '../../../../utils/map_firebase_error.dart';
import '../model/notification_model.dart';

part 'notification_state.dart';

class NotificationCubit extends Cubit<NotificationState> {
  NotificationCubit({required this.loc}) : super(NotificationInitial());

  final S loc;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> getNotifications() async {
    emit(NotificationLoading());

    if (!await hasInternetConnection()) return;

    try {
      final snapshot =
          await _firestore
              .collection("notifications")
              .orderBy("timestamp", descending: true)
              .get();

      final notifications =
          snapshot.docs
              .map((doc) => NotificationModel.fromMap(doc.data()))
              .toList();

      emit(NotificationLoadedSuccess(notifications));
    } on FirebaseException catch (e) {
      emit(
        NotificationError(
          failure: localizeFirestoreError(loc: loc, code: e.code),
        ),
      );
    } catch (e) {
      emit(NotificationError(failure: "${loc.Unknown}: $e"));
    }
  }

  Future<bool> hasInternetConnection() async {
    final List<ConnectivityResult> connectivityResult =
        await Connectivity().checkConnectivity();

    final hasConnection = !connectivityResult.contains(ConnectivityResult.none);

    if (!hasConnection) {
      emit(NoInternetConnectionState(message: loc.unavailable));
    }

    return hasConnection;
  }
}
