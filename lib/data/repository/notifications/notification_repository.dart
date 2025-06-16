import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../../abstract/base_repository.dart';
import '../../services/notifications/notification_model.dart';
import '../authentication_repository/authentication_repository.dart';

class NotificationRepository extends TBaseRepositoryController<NotificationModel> {
  static NotificationRepository get instance => Get.isRegistered() ? Get.find() : Get.put(NotificationRepository());

  @override
  Future<String> addItem(NotificationModel item) async {
    final result = await db.collection("Notifications").add(item.toJson());
    return result.id;
  }

  @override
  Future<List<NotificationModel>> fetchAllItems() async {
    final String currentUserId = AuthenticationRepository.instance.getUserID;
    if (currentUserId.isEmpty) return [];

    final snapshot = await db
        .collection("Notifications")
        .where('recipientIds', arrayContains: currentUserId)
        .orderBy('createdAt', descending: true)
        .get();

    final result = snapshot.docs.map((e) => NotificationModel.fromDocSnapshot(e)).toList();
    return result;
  }

  Stream<List<NotificationModel>> fetchAllItemsAsStream() {
    final String currentUserId = AuthenticationRepository.instance.getUserID;
    if (currentUserId.isEmpty) return const Stream.empty(); // Return an empty stream if user ID is empty

    return db
        .collection("Notifications")
        .where('recipientIds', arrayContains: currentUserId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => NotificationModel.fromDocSnapshot(doc)).toList());
  }

  @override
  Future<NotificationModel> fetchSingleItem(String id) async {
    final snapshot = await db.collection("Notifications").doc(id).get();
    final result = NotificationModel.fromDocSnapshot(snapshot);
    return result;
  }

  @override
  NotificationModel fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc) {
    return NotificationModel.fromQuerySnapshot(doc);
  }

  @override
  Query getPaginatedQuery(limit) {
    final String currentUserId = AuthenticationRepository.instance.getUserID;

    if (currentUserId.isEmpty) {
      // Return an empty query by using a condition that will always be false
      return db.collection('Notifications').where('recipientIds', isEqualTo: '__invalid__');
    }

    return db
        .collection('Notifications')
        .where('recipientIds', arrayContains: currentUserId)
        .orderBy('createdAt', descending: true)
        .limit(limit);
  }

  @override
  Future<void> updateItem(NotificationModel item) async {
    await db.collection("Notifications").doc(item.id).update(item.toJson());
  }

  @override
  Future<void> updateSingleField(String id, Map<String, dynamic> json) async {
    await db.collection("Notifications").doc(id).update(json);
  }

  @override
  Future<void> deleteItem(NotificationModel item) async {
    await db.collection("Notifications").doc(item.id).delete();
  }

  Future<void> markNotificationAsSeen(String notificationId, String userId) async {
    try {
      // Reference to the notification document
      final notificationRef = db.collection("Notifications").doc(notificationId);

      // Update the 'seenBy' field for the specific user
      await notificationRef.update({
        'seenBy.$userId': true,
        'seenAt': FieldValue.serverTimestamp(), // Optionally, update the 'seenAt' timestamp
      });

      print('Notification marked as seen by user $userId');
    } catch (e) {
      print('Error marking notification as seen: $e');
      throw Exception('Failed to mark notification as seen');
    }
  }
}
