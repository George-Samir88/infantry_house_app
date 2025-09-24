import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> collectionExists({
  required CollectionReference collectionRef,
}) async {
  final snapshot = await collectionRef.limit(1).get();
  return snapshot.docs.isNotEmpty;
}
