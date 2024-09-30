import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/settings/locked_email_textfield.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math' show min;

/// Profile Settings Screen
/// here you can edit your profile picture and your name
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  final TextEditingController _nameController = TextEditingController();

  // State variables to track changes
  bool _isProfileChanged = false;
  String currentUserName = '';
  bool _isProfilePictureChanged = false;
  // State variables to hold user info
  String currentUserEmail = '';
  String _profileImageUrl = '';
  File? _profileImage;
  bool isLoading = true;

  final ImagePicker _picker = ImagePicker();

  final User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    // detect changes
    _nameController.addListener(_checkIfProfileChanged);
  }

  // Function to check if profile has been modified
  void _checkIfProfileChanged() {
    setState(() => _isProfileChanged = _nameController.text.trim() != currentUserName.trim() || _isProfilePictureChanged);
  }

  Future<Map<String, dynamic>> getCurrentUserData() async {
    if (user != null) {
      try {
        debugPrint('Attempting to fetch data for user ID: ${user!.uid}');
        DocumentSnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance.collection('users').doc(user!.uid).get();

        if (snapshot.exists) {
          debugPrint('Document data: ${snapshot.data()}');
          return snapshot.data() ?? {};
        } else {
          debugPrint('User document does not exist');
          return {};
        }
      } catch (e) {
        debugPrint('Error fetching user data: $e');
        return {};
      }
    }
    debugPrint('null');
    return {};
  }

  Future<void> _loadUserData() async {
    try {
      Map<String, dynamic> userData = await getCurrentUserData();
      debugPrint('Received user data: $userData');
      setState(() {
        currentUserName = userData['name'] ?? 'Unbekannter Benutzer';
        currentUserName == 'Unbekannter Benutzer' ? debugPrint('Name field not found in user data') : null;

        _nameController.text = currentUserName;

        currentUserEmail = userData['email'] ?? '';
        currentUserEmail == '' ? debugPrint('email field not found in user data') : null;

        _profileImageUrl = userData['profilePictureUrl'] ?? '';
        _profileImageUrl == '' ? debugPrint('profilePictureUrl not found in user data') : null;
        isLoading = false;
      });
    } catch (e) {
      debugPrint('Error in _loadUserData: $e');
      setState(() {
        currentUserName = 'Fehler beim Laden der Benutzerdaten: $e';
        isLoading = false;
      });
    }
  }

  // method to save profile changes
  Future<void> _saveProfileChanges() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    try {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        final updatedName = _nameController.text.trim();

        if (_isProfilePictureChanged && _profileImage != null) {
          // If there was an existing profile image, delete it first
          if (_profileImageUrl.isNotEmpty) {
            await deleteProfileImage(userId);
          }

          final String? profileImageUrl = await uploadProfileImage(_profileImage!, userId);

          if (profileImageUrl != null) {
            // Update Firestore
            await FirestoreService().updateUserProfileImageInFirestore(userId, profileImageUrl);
          }
        }

        // Update name in Firestore
        await FirestoreService().updateUserNameInFirestore(userId, updatedName);

        if (mounted) {
          // Pop the current screen and return true to indicate changes were made
          Navigator.of(context).pop(true);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fehler beim Aktualisieren des Profils: $e",
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    }
  }

  Future<void> deleteProfileImage(String userId) async {
    try {
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId');
      await storageRef.delete();
      debugPrint("Old profile image deleted successfully");
    } catch (e) {
      debugPrint("Error deleting old profile image: $e");
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // Compress the image
      final compressedImage = await compressImage(File(image.path));

      setState(() {
        _profileImage = compressedImage;
        _isProfilePictureChanged = true;
        _checkIfProfileChanged();
      });
    }
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jpg'));
    final splitName = filePath.substring(0, (lastIndex));
    final outPath = "${splitName}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(file.absolute.path, outPath, quality: 70);

    return File(result!.path);
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Create a reference to the location where the file will be stored
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId');

      // Compress the image before uploading
      final compressedImage = await compressImage(imageFile);

      // Upload the compressed image file to Firebase Storage
      final uploadTask = storageRef.putFile(compressedImage);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      debugPrint("Fehler beim Hochladen des Bildes: $e");
      return null;
    }
  }

  Future<void> saveProfileImageUrl(String userId, String imageUrl) async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    try {
      // Reference to the Firestore collection where you store user profiles
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Update the profile image URL
      await userRef.update({'profileImageUrl': imageUrl});

      // Optional: Show a success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Profilbild erfolgreich hochgeladen und gespeichert.",
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Fehler beim Speichern der Bild-URL: $e",
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Scaffold(
        appBar: AppBar(
            title: Text(AppTexts.editProfile, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
            centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            // add Space
            padding: EdgeInsets.only(
                top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceAuth - Constants.defaultAppBarHeight,
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace,
                bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace),

            child: Column(
              children: [
                // Profile picture widget
                Center(
                  child: GestureDetector(
                    onTap: () {
                      _pickImage();
                      setState(() {
                        _checkIfProfileChanged();
                      });
                    },
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        // Main profile picture
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: SizedBox(
                            width: Constants.profilePictureAccountEdit,
                            height: Constants.profilePictureAccountEdit,
                            child: _profileImage != null
                                ? Image.file(
                                    _profileImage!,
                                    fit: BoxFit.cover,
                                  )
                                : _profileImageUrl.isNotEmpty
                                    ? Image.network(
                                        _profileImageUrl,
                                        fit: BoxFit.cover,
                                      )
                                    : const Icon(Icons.person, size: 100, color: Colors.grey),
                          ),
                        ),
                        // Camera icon overlay
                        ClipRRect(
                          borderRadius: BorderRadius.circular(Constants.roundedCorners),
                          child: Container(
                            width: 30,
                            height: 30,
                            color: defaultColorScheme.outline,
                            child: SvgPicture.asset(AssetImport.camera,
                                fit: BoxFit.scaleDown, colorFilter: ColorFilter.mode(defaultColorScheme.secondary, BlendMode.srcIn)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const Gap(CustomPadding.bigSpace),
                // First Name text field
                CustomTextfield(name: AppTexts.firstName, hintText: '', controller: _nameController),
                const Gap(CustomPadding.defaultSpace),
                // Email text field (locked)
                LockedEmailTextfield(email: currentUserEmail),
              ],
            ),
          ),
        ),
        // Bottom sheet with Save button
        bottomSheet: Container(
          color: defaultColorScheme.onSurface,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(
                bottom: min(
                    MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : MediaQuery.of(context).size.height * CustomPadding.bottomSpace,
                    MediaQuery.of(context).size.height * CustomPadding.bottomSpace),
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace),
            width: MediaQuery.of(context).size.width,
            // Save Button
            child: ElevatedButton(
              onPressed: _isProfileChanged ? _saveProfileChanges : null,
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
                backgroundColor: CustomColor.bluePrimary,
                elevation: 0, // Remove shadow
              ),
              child: Text(AppTexts.save),
            ),
          ),
        ));
  }
}
