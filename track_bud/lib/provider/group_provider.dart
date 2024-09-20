import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/services/firestore_service.dart'; // Import Firebase Storage

class GroupProvider with ChangeNotifier {
  final List<GroupModel> _groups = [];
  bool _isLoading = false;

  List<GroupModel> get groups => _groups;
  bool get isLoading => _isLoading;

  Future<void> loadGroups() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Fetch groups from Firestore
      final groups = await FirestoreService().getGroups();
      _groups.clear();
      _groups.addAll(groups);
    } catch (e) {
      debugPrint("Error loading groups: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createGroup(GroupModel group, File? imageFile) async {
    try {
      // 1. Create the group in Firestore first
      await FirestoreService().createGroup(group);

      // 2. If an image was selected, upload it to Firebase Storage and get the URL
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await uploadGroupImage(imageFile, group.groupId);

        // 3. If the image was uploaded successfully, update the group with the image URL
        if (imageUrl != null) {
          await FirebaseFirestore.instance
              .collection('groups')
              .doc(group.groupId)
              .update({'profilePictureUrl': imageUrl});
        }
      }

      // 4. Add the new group to the local list and notify listeners
      _groups.add(group);
      notifyListeners();
    } catch (e) {
      // Handle errors
      debugPrint("Error creating group: $e");
      rethrow;
    }
  }

  // Helper method to upload image to Firebase Storage
  Future<String?> uploadGroupImage(File imageFile, String groupId) async {
    try {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('group_images')
          .child('$groupId.jpg');

      // Upload the file to Firebase Storage
      final uploadTask = await storageRef.putFile(imageFile);

      // Get the download URL after the upload is complete
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      debugPrint("Error uploading image: $e");
      return null;
    }
  }
}
