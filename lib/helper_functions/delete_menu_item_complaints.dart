import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> deleteMenuItemComplaints({
  required String menuItemId,
  required FirebaseFirestore firestore,
}) async {
  final complaintsDocRef = firestore
      .collection('menu_items_complaint')
      .doc(menuItemId);

  // لو فيه feedback collection تحتها امسحه
  final feedbackSnapshot = await complaintsDocRef.collection('feedback').get();
  for (var feedbackDoc in feedbackSnapshot.docs) {
    await feedbackDoc.reference.delete();
  }

  // امسح doc نفسه بعد ما تخلص
  await complaintsDocRef.delete();
}
