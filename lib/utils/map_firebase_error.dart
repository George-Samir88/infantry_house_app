// ==============================
// Helper: Map Firestore Errors
// ==============================

import 'package:cloud_firestore/cloud_firestore.dart';

import '../generated/l10n.dart';

String mapFirestoreError({required FirebaseException e}) {
  switch (e.code) {
    case "permission-denied":
      return "permission-denied";
    case "unavailable":
      return "unavailable";
    case "not-found":
      return "not-found";
    case "already-exists":
      return "already-exists";
    case "cancelled":
      return "cancelled";
    case "deadline-exceeded":
      return "deadline-exceeded";
    case "resource-exhausted":
      return "resource-exhausted";
    case "failed-precondition":
      return "failed-precondition";
    case "aborted":
      return "aborted";
    case "internal":
      return "internal";
    case "unimplemented":
      return "unimplemented";
    case "unauthenticated":
      return "unauthenticated";
    case "network-error":
      return "network-error";
    case "network-request-failed":
      return "network-request-failed";
    default:
      return "unknown";
  }
}

// Helper method for localization
String localizeFirestoreError({required S loc, required String code}) {
  switch (code) {
    // Authentication & Permission
    case "permission-denied":
      return loc.PermissionDenied;
    case "unauthenticated":
      return loc.unauthenticated;

    // Resource state
    case "not-found":
      return loc.NotFound;
    case "already-exists":
      return loc.AlreadyExists;

    // Operation state
    case "cancelled":
      return loc.cancelled;
    case "aborted":
      return loc.aborted;
    case "failed-precondition":
      return loc.FailedPrecondition;
    case "out-of-range":
      return loc.OutOfRange;

    // Quotas & limits
    case "resource-exhausted":
      return loc.ResourceExhausted;

    // Timeouts
    case "deadline-exceeded":
      return loc.DeadlineExceeded;

    // Server & internal issues
    case "unavailable":
      return loc.Unavailable;
    case "internal":
      return loc.Internal;
    case "unimplemented":
      return loc.Unimplemented;
    case "data-loss":
      return loc.DataLoss;

    // Network issues
    case "network-error":
    case "network-request-failed":
      return loc.NetworkError;

    // Default fallback
    default:
      return "${loc.Unknown} ${code.toString()} ";
  }
}

String localizeAuthError({required S loc, required String code}) {
  switch (code) {
    case "invalid-email":
      return loc.InvalidEmail;
    case "user-disabled":
      return loc.UserDisabled;
    case "user-not-found":
      return loc.UserNotFound;
    case "wrong-password":
      return loc.WrongPassword;
    case "email-already-in-use":
      return loc.EmailAlreadyInUse;
    case "operation-not-allowed":
      return loc.OperationNotAllowed;
    case "weak-password":
      return loc.WeakPassword;
    case "requires-recent-login":
      return loc.RequiresRecentLogin;
    case "too-many-requests":
      return loc.TooManyRequests;
    case "network-request-failed":
      return loc.NetworkError;
    case "invalid-verification-code":
      return loc.InvalidVerificationCode;
    case "invalid-verification-id":
      return loc.InvalidVerificationId;
    default:
      return "${loc.Unknown} ${code.toString()} ";
  }
}
