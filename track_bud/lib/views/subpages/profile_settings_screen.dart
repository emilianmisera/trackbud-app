import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/button_widgets/acc_adjustment_button.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/settings/locked_email_textfield.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/views/at_signup/firestore_service.dart';
import 'package:track_bud/views/subpages/change_email_screen.dart';
import 'package:track_bud/views/subpages/change_password_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:math' show min;

// Profile Settings Screen
class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});
  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  // Controller for the name text field
  final TextEditingController _nameController = TextEditingController();

  // State variables to track changes
  bool _isProfileChanged = false;
  String _initialName = '';
  bool _isProfilePictureChanged = false;
  // State variables to hold user info
  String currentUserEmail = '';
  String _initialProfileImagePath = '';
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    //_loadCurrentUserInfo();
    // Add listener to name controller to detect changes
    _nameController.addListener(_checkIfProfileChanged);
  }

  // Function to check if profile has been modified
  void _checkIfProfileChanged() {
    setState(() {
      _isProfileChanged = _nameController.text.trim() != _initialName.trim() || _isProfilePictureChanged;
    });
  }

/*
  Future<void> _loadCurrentUserInfo() async {
    final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';

    if (userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Benutzer nicht angemeldet."),
        ),
      );
      return;
    }

    try {
      UserModel? localUser = await SQLiteService().getUserById(userId);
      print('Loaded user name from SQLite: ${localUser?.name}');
      await DependencyInjector.syncService.syncData(userId);
      if (localUser != null) {
        setState(() {
          _initialName = localUser.name;
          _nameController.text = localUser.name;
          currentUserEmail = localUser.email;
          _initialProfileImagePath = localUser.profilePictureUrl;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Laden der Nutzerdaten: $e")),
      );
    }
  }
*/
  // New method to save profile changes
  Future<void> _saveProfileChanges() async {
    try {
      final String userId = FirebaseAuth.instance.currentUser?.uid ?? '';
      if (userId.isNotEmpty) {
        final updatedName = _nameController.text.trim();

        if (_isProfilePictureChanged && _profileImage != null) {
          final String? profileImageUrl = await uploadProfileImage(_profileImage!, userId);

          if (profileImageUrl != null) {
            // Update Firestore
            await FirestoreService().updateUserProfileImageInFirestore(userId, profileImageUrl);

            // Update local database
            //await SQLiteService().updateUserProfileImage(userId, profileImageUrl);
          }
        }

        // Update name in Firestore
        await FirestoreService().updateUserNameInFirestore(userId, updatedName);

        // Update local database
        //await SQLiteService().updateUserName(userId, updatedName);

        // Sync data
        //await DependencyInjector.syncService.syncData(userId);

        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Aktualisieren des Profils: $e")),
      );
    }
  }

  // Function to pick an image from the gallery
  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _profileImage = File(image.path); // Store the selected image
        _isProfilePictureChanged = true;
        _checkIfProfileChanged();
      });
    }
  }

  Future<String?> uploadProfileImage(File imageFile, String userId) async {
    try {
      // Create a reference to the location where the file will be stored
      final storageRef = FirebaseStorage.instance.ref().child('profile_images/$userId');

      // Upload the image file to Firebase Storage
      final uploadTask = storageRef.putFile(imageFile);

      // Wait for the upload to complete
      final snapshot = await uploadTask.whenComplete(() => null);

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();

      // Return the download URL
      return downloadUrl;
    } catch (e) {
      print("Fehler beim Hochladen des Bildes: $e");
      return null;
    }
  }

  Future<void> saveProfileImageUrl(String userId, String imageUrl) async {
    try {
      // Reference to the Firestore collection where you store user profiles
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);

      // Update the profile image URL
      await userRef.update({
        'profileImageUrl': imageUrl,
      });

      // Optional: Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Profilbild erfolgreich hochgeladen und gespeichert.")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Speichern der Bild-URL: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with title
      appBar: AppBar(
        title: Text(AppTexts.editProfile, style: TextStyles.regularStyleMedium),
      ),
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
                        child: Container(
                          width: Constants.profilePictureAccountEdit,
                          height: Constants.profilePictureAccountEdit,
                          child: _profileImage != null
                              ? Image.file(
                                  _profileImage!,
                                  fit: BoxFit.cover,
                                )
                              : _initialProfileImagePath.isNotEmpty
                                  ? Image.network(
                                      _initialProfileImagePath,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.person, size: 100, color: Colors.grey),
                        ),
                      ),
                      // Camera icon overlay
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: Container(
                          width: 30,
                          height: 30,
                          color: CustomColor.grey,
                          child: SvgPicture.asset(
                            AssetImport.camera,
                            fit: BoxFit.scaleDown,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Gap(CustomPadding.bigSpace),
              // First Name text field
              CustomTextfield(name: AppTexts.firstName, hintText: '', controller: _nameController),
              Gap(CustomPadding.defaultSpace),
              // Email text field (locked)
              LockedEmailTextfield(email: currentUserEmail),
              Gap(CustomPadding.defaultSpace),
              // Change Email button
              AccAdjustmentButton(
                icon: AssetImport.email,
                name: AppTexts.changeEmail,
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangeEmailScreen())),
                padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace),
              ),
              // Change Password button
              AccAdjustmentButton(
                icon: AssetImport.userEdit,
                name: AppTexts.changePassword,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChangePasswordScreen(),
                    ),
                  );
                },
                padding: EdgeInsets.symmetric(horizontal: CustomPadding.mediumSpace),
              ),
            ],
          ),
        ),
      ),
      // Bottom sheet with Save button
      bottomSheet: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        curve: Curves.easeInOut,
        margin: EdgeInsets.only(
          bottom: min(MediaQuery.of(context).viewInsets.bottom > 0 ? 0 : MediaQuery.of(context).size.height * CustomPadding.bottomSpace,
              MediaQuery.of(context).size.height * CustomPadding.bottomSpace),
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
        ),
        width: MediaQuery.of(context).size.width,
        child: ElevatedButton(
          // Enable button only if profile has changed
          onPressed: _isProfileChanged ? _saveProfileChanges : null,
          style: ElevatedButton.styleFrom(
              // Set button color based on whether profile has changed
              disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
              backgroundColor: CustomColor.bluePrimary),
          child: Text(AppTexts.save),
        ),
      ),
    );
  }
}
