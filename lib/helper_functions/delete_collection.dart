import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteCollection(CollectionReference colRef) async {
  const int batchSize = 400; // أقل من 500 عشان الأمان
  QuerySnapshot snapshot;
  do {
    snapshot = await colRef.limit(batchSize).get();
    if (snapshot.docs.isEmpty) break;

    WriteBatch batch = FirebaseFirestore.instance.batch();

    for (var doc in snapshot.docs) {
      batch.delete(doc.reference);
    }

    await batch.commit();
  } while (snapshot.docs.length >= batchSize);
}
