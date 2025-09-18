// ==============================
// Helper: Map Firestore Errors
// ==============================

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../generated/l10n.dart';

String _mapFirestoreError({required FirebaseException e}) {
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
String localizeFirestoreError({
  required BuildContext context,
  required String code,
}) {
  switch (code) {
    case "permission-denied":
      return S.of(context).PermissionDenied;
    case "unavailable":
      return S.of(context).unavailable;
    case "not-found":
      return S.of(context).NotFound;
    case "already-exists":
      return S.of(context).AlreadyExists;
    case "cancelled":
      return S.of(context).cancelled;
    case "deadline-exceeded":
      return S.of(context).DeadlineExceeded;
    case "resource-exhausted":
      return S.of(context).ResourceExhausted;
    case "failed-precondition":
      return S.of(context).FailedPrecondition;
    case "aborted":
      return S.of(context).aborted;
    case "internal":
      return S.of(context).internal;
    case "unimplemented":
      return S.of(context).unimplemented;
    case "unauthenticated":
      return S.of(context).unauthenticated;
    case "network-error":
    case "network-request-failed":
      return S.of(context).NetworkError;
    default:
      return S.of(context).unknown;
  }
}
