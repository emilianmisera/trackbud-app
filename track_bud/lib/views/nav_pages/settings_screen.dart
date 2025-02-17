import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/views/at_signup/onboarding_screen.dart';
import 'package:track_bud/views/subpages/about_trackbud_screen.dart';
import 'package:track_bud/views/subpages/account_settings_screen.dart';
import 'package:track_bud/views/subpages/profile_settings_screen.dart';

/// This is the Settings Screen
/// It is one of the Naviagtion Pages
/// It displays the Profile Picture and the User can choose
/// between Profile Settings, Account Settings, See Something about the TrackBud Team
/// or Logout
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _passwordController = TextEditingController();
  // State variables to hold user info
  final User? user = FirebaseAuth.instance.currentUser;
  String currentUserName = '';
  String currentUserEmail = '';
  String? _profileImageUrl;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
        // Navigate to OnboardingScreen after Logout
        Navigator.of(context)
            .pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const OnboardingScreen()), (Route<dynamic> route) => false);
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
          padding: EdgeInsets.only(
              top: MediaQuery.sizeOf(context).height * CustomPadding.topSpaceSettingsScreen,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(Constants.roundedCorners),
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
              // Username
              Center(child: Text(currentUserName, style: TextStyles.titleStyleMedium.copyWith(color: defaultColorScheme.primary))),
              const Gap(CustomPadding.smallSpace),
              //email
              Center(child: Text(currentUserEmail, style: TextStyles.hintStyleDefault.copyWith(color: defaultColorScheme.secondary))),
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
            ],
          )),
    );
  }
}
