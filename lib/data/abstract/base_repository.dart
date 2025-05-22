import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../utils/exceptions/firebase_exceptions.dart';
import '../../utils/exceptions/format_exceptions.dart';
import '../../utils/exceptions/platform_exceptions.dart';

/// A generic controller class for managing data tables using GetX state management.
/// This class provides common functionalities for handling data tables, including fetching, updating, and deleting items.
abstract class TBaseRepositoryController<T> extends GetxController {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  // Variable to store the last document fetched for pagination
  QueryDocumentSnapshot? lastFetchedDocument;

  /// Abstract method to be implemented by subclasses for fetching all items.
  Future<List<T>> fetchAllItems();

  /// Abstract method to be implemented by subclasses for fetching a single item by ID.
  Future<T> fetchSingleItem(String id);

  /// Abstract method to be implemented by subclasses for adding a new item.
  Future<String> addItem(T item);

  /// Abstract method to be implemented by subclasses for updating an existing item.
  Future<void> updateItem(T item);

  /// Abstract method to be implemented by subclasses for updating a single field of an item by ID.
  Future<void> updateSingleField(String id, Map<String, dynamic> json);

  /// Abstract method to be implemented by subclasses for deleting an item.
  Future<void> deleteItem(T item);

  /// Fetches all items and handles exceptions using a centralized method.
  Future<List<T>> getAllItems() async {
    return await _handleFirestoreOperation(() => fetchAllItems());
  }

  /// Fetches a single item by ID and handles exceptions.
  Future<T> getSingleItem(String id) async {
    return await _handleFirestoreOperation(() => fetchSingleItem(id));
  }

  /// Adds a new item and handles exceptions.
  Future<String> addNewItem(T item) async {
    return await _handleFirestoreOperation(() => addItem(item));
  }

  /// Updates an existing item and handles exceptions.
  Future<void> updateItemRecord(T item) async {
    await _handleFirestoreOperation(() => updateItem(item));
  }

  /// Updates a single field of an item and handles exceptions.
  Future<void> updateSingleItemRecord(String id, Map<String, dynamic> json) async {
    await _handleFirestoreOperation(() => updateSingleField(id, json));
  }

  /// Deletes an item and handles exceptions.
  Future<void> deleteItemRecord(T item) async {
    await _handleFirestoreOperation(() => deleteItem(item));
  }

  /// Fetches items with pagination and handles exceptions.
  Future<List<T>> fetchPaginatedItems(int limit) async {
    return await _handleFirestoreOperation(() async {
      Query query = getPaginatedQuery(limit);

      // If there's a last fetched document, start after it
      if (lastFetchedDocument != null) {
        query = query.startAfterDocument(lastFetchedDocument!);
      }

      // Fetch the data
      final querySnapshot = await query.get();

      // If there are documents, store the last one for pagination
      if (querySnapshot.docs.isNotEmpty) {
        lastFetchedDocument = querySnapshot.docs.last;
      }

      // Convert to model list
      return querySnapshot.docs.map((doc) => fromQueryDocSnapshot(doc)).toList();
    });
  }

  /// Abstract method to get the collection path for pagination.
  Query getPaginatedQuery(int limit);

  /// Abstract method to convert DocumentSnapshot to model.
  T fromQueryDocSnapshot(QueryDocumentSnapshot<Object?> doc);

  /// Centralized method to handle Firestore operations and catch exceptions.
  Future<R> _handleFirestoreOperation<R>(Future<R> Function() operation) async {
    try {
      return await operation();
    } on FirebaseException catch (e) {
      // Handle Firestore-specific exceptions
      throw TFirebaseException(e.code).message;
    } on FormatException catch (_) {
      // Handle format exceptions
      throw const TFormatException();
    } on PlatformException catch (e) {
      // Handle platform-specific exceptions
      throw TPlatformException(e.code).message;
    } catch (e) {
      // Handle any other exceptions
      throw 'Something went wrong. Please try again';
    }
  }
}
