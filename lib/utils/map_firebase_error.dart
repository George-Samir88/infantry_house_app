// ==============================
// Helper: Map Firestore Errors
// ==============================
import 'package:cloud_firestore/cloud_firestore.dart';

String mapFirestoreError({required FirebaseException e}) {
  switch (e.code) {
    case "permission-denied":
      return "You don’t have permission to perform this action.";
    case "unavailable":
      return "Firestore service is temporarily unavailable. Try again later.";
    case "not-found":
      return "The requested document was not found.";
    case "already-exists":
      return "A document with this ID already exists.";
    case "cancelled":
      return "The request was cancelled.";
    case "deadline-exceeded":
      return "The request took too long. Please try again.";
    case "resource-exhausted":
      return "Quota exceeded. Too many requests.";
    case "failed-precondition":
      return "The operation is not allowed in the current state.";
    case "aborted":
      return "The operation was aborted. Please retry.";
    case "internal":
      return "An internal Firestore error occurred.";
    case "unimplemented":
      return "This operation is not supported.";
    case "unauthenticated":
      return "You must be signed in to perform this action.";
    case "network-error":
    case "network-request-failed":
      return "No internet connection.";
    default:
      return e.message ?? "An unknown Firestore error occurred.";
  }
}
