import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/settings/delete_account_pop_up.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/at_signup/onboarding_screen.dart';
import 'package:track_bud/views/subpages/about_trackbud_screen.dart';
import 'package:track_bud/views/subpages/account_settings_screen.dart';
import 'package:track_bud/views/subpages/notifications_settings_screen.dart';
import 'package:track_bud/views/subpages/profile_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _passwordController = TextEditingController();
  // State variables to hold user info
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseService _firebaseService = FirebaseService();
  String currentUserName = '';
  String currentUserEmail = '';
  String? _profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

// DELETE USER ACCOUNT (dont delete from firestore DB yet, so friends still see shared costs etc)
  Future<void> _handleAccountDeletion(BuildContext context) async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    try {
      // Get the password entered by the user
      String password = _passwordController.text;

      // Attempt to delete the user account
      await _firebaseService.deleteUserAccount(password);

      submit();

      // Show success message and navigate away or logout the user
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content:
                Text('Konto erfolgreich gelöscht.', style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }

      // navigate the user to a login or home screen after deletion
      if (context.mounted) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const OnboardingScreen()));
      }
    } catch (e) {
      submit();
      // Show error message if something goes wrong
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Fehler beim Löschen des Kontos: $e',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))));
      }
    }
  }

  void submit() {
    // hide allert dialog when button is pressed
    _passwordController.clear();
    Navigator.of(context).pop();
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

        currentUserEmail = userData['email'] ?? '';
        currentUserEmail == '' ? debugPrint('email field not found in user data') : null;

        _profileImageUrl = userData['profilePictureUrl'] ?? '';
        _profileImageUrl == '' ? debugPrint('email field not found in user data') : null;
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

  Future<void> logout() async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final FirebaseService firebaseService = FirebaseService();

    try {
      debugPrint('logout: Versuche, den Benutzer abzumelden...');
      await firebaseService.signOut();
      debugPrint('logout: Benutzer erfolgreich abgemeldet');
      if (mounted) {
        // Navigieren Sie zur Login-Seite und entfernen Sie alle vorherigen Routen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const OnboardingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint('logout: Fehler beim Abmelden des Benutzers: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Fehler beim Abmelden: ${e.toString()}',
                  style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return SingleChildScrollView(
      child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceSettingsScreen,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: SizedBox(
                    width: Constants.profilePictureSettingPage,
                    height: Constants.profilePictureSettingPage,
                    child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                        ? Image.network(
                            _profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.person, size: 100, color: Colors.grey);
                            },
                          )
                        : const Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              Center(
                  // Username
                  child: Text(currentUserName, style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary))),
              const Gap(CustomPadding.smallSpace),
              Center(
                  //email
                  child: Text(currentUserEmail, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary))),
              const Gap(CustomPadding.bigbigSpace),
              Text(AppTexts.preferences, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              const Gap(CustomPadding.defaultSpace),
              CustomShadow(
                // edit Profile Button
                child: TextButton.icon(
                  onPressed: () async {
                    final bool? result = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(builder: (context) => const ProfileSettingsScreen()),
                    );
                    if (result == true) {
                      // Reload user data if changes were made
                      _loadUserData();
                    }
                  },
                  label: Text(AppTexts.editProfile, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
                  icon: SvgPicture.asset(
                    AssetImport.userEdit,
                    colorFilter: ColorFilter.mode(defaultColorScheme.primary, BlendMode.srcIn),
                  ),
                  style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              CustomShadow(
                // accAdjustment button
                child: TextButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AccountSettingsScreen())),
                  label: Text(AppTexts.accAdjustments, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
                  icon: SvgPicture.asset(
                    AssetImport.settings,
                    colorFilter: ColorFilter.mode(defaultColorScheme.primary, BlendMode.srcIn),
                  ),
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              /*
              CustomShadow(
                // notification button
                child: TextButton.icon(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const NotificationsSettingsScreen())),
                  label: Text(AppTexts.notifications,
                      style: TextStyles.regularStyleDefault),
                  icon: SvgPicture.asset(AssetImport.bell),
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              */
              CustomShadow(
                // aboutTrackbut button
                child: TextButton.icon(
                  onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutTrackbudScreen())),
                  label: Text(AppTexts.abouTrackBud, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
                  icon: SvgPicture.asset(
                    AssetImport.info,
                    colorFilter: ColorFilter.mode(defaultColorScheme.primary, BlendMode.srcIn),
                  ),
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              CustomShadow(
                // Logout Button
                child: TextButton.icon(
                  onPressed: () => logout(),
                  label: Text(AppTexts.logout, style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary)),
                  icon: SvgPicture.asset(
                    AssetImport.logout,
                    colorFilter: ColorFilter.mode(defaultColorScheme.primary, BlendMode.srcIn),
                  ),
                  style: const ButtonStyle(alignment: Alignment.centerLeft),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              CustomShadow(
                // delete Account Button
                child: TextButton.icon(
                  onPressed: () => showDialog(
                      context: context,
                      builder: (context) => DeleteAccountPopUp(onPressed: () => _handleAccountDeletion(context))), //_handleAccountDeletion,
                  label: Text(
                    AppTexts.deleteAcc,
                    style: const TextStyle(
                      fontFamily: TextStyles.fontFamily,
                      fontSize: TextStyles.fontSizeDefault,
                      fontWeight: TextStyles.fontWeightDefault,
                      color: CustomColor.red,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    AssetImport.trash,
                    colorFilter: const ColorFilter.mode(CustomColor.red, BlendMode.srcIn),
                  ),
                  style: const ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
