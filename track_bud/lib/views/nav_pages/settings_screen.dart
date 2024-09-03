import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/services/auth/firebase_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/textfield.dart';
import 'package:track_bud/views/at_signup/onboarding_screen.dart';
import 'package:track_bud/views/subpages/about_trackbud_screen.dart';
import 'package:track_bud/views/subpages/account_settings_screen.dart';
import 'package:track_bud/views/subpages/notifications_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

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
    final AuthService authService = AuthService();

    try {
      debugPrint('logout: Versuche, den Benutzer abzumelden...');
      await authService.signOut();
      debugPrint('logout: Benutzer erfolgreich abgemeldet');
      if (mounted) {
        // Navigieren Sie zur Login-Seite und entfernen Sie alle vorherigen Routen
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OnboardingScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } catch (e) {
      debugPrint('logout: Fehler beim Abmelden des Benutzers: ${e.toString()}');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fehler beim Abmelden: ${e.toString()}')),
        );
      }
    }
  }

  Future openPopUp() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            AppTexts.deleteAcc,
            style: TextStyles.titleStyleMedium,
          ),
          content: Container(
            width: double.infinity,
            height: 235,
            child: Column(
              children: [
                Text(
                  AppTexts.deleteAccDescribtion,
                  style: TextStyles.hintStyleDefault,
                ),
                Gap(
                  CustomPadding.defaultSpace,
                ),
                CustomTextfield(
                  name: AppTexts.password,
                  obscureText: true,
                  hintText: AppTexts.hintPassword,
                  controller: _passwordController,
                  autofocus: true,
                ),
                Gap(
                  CustomPadding.defaultSpace,
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: CustomColor.red),
                  child: Text(
                    AppTexts.deleteAcc,
                  ),
                )
              ],
            ),
          ),
          insetPadding: EdgeInsets.all(CustomPadding.defaultSpace),
          backgroundColor: CustomColor.backgroundPrimary,
          surfaceTintColor: CustomColor.backgroundPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(Constants.contentBorderRadius),
            ),
          ),
        ),
      );

  void submit() {
    // hide allert dialog when button is pressed
    _passwordController.clear();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Container(
                    width: Constants.profilePictureSettingPage,
                    height: Constants.profilePictureSettingPage,
                    child: _profileImageUrl != null && _profileImageUrl!.isNotEmpty
                        ? Image.network(
                            _profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(Icons.person, size: 100, color: Colors.grey);
                            },
                          )
                        : Icon(Icons.person, size: 50, color: Colors.grey),
                  ),
                ),
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              Center(
                  child: Text(
                // FirstName
                currentUserName,
                style: TextStyles.titleStyleMedium,
              )),
              Gap(
                CustomPadding.smallSpace,
              ),
              Center(
                  child: Text(
                //email
                currentUserEmail,
                style: TextStyles.hintStyleDefault,
              )),
              Gap(
                CustomPadding.bigbigSpace,
              ),
              Text(
                AppTexts.preferences,
                style: TextStyles.regularStyleMedium,
              ),
              Gap(
                CustomPadding.defaultSpace,
              ),
              CustomShadow(
                // edit Profile Button
                child: TextButton.icon(
                  onPressed: () async {},
                  label: Text(
                    AppTexts.editProfile,
                    style: TextStyles.regularStyleDefault,
                  ),
                  icon: SvgPicture.asset(AssetImport.userEdit),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              CustomShadow(
                // accAdjustment button
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AccountSettingsScreen(),
                      ),
                    );
                  },
                  label: Text(
                    AppTexts.accAdjustments,
                    style: TextStyles.regularStyleDefault,
                  ),
                  icon: SvgPicture.asset(AssetImport.settings),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              CustomShadow(
                // notification button
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationsSettingsScreen(),
                      ),
                    );
                  },
                  label: Text(
                    AppTexts.notifications,
                    style: TextStyles.regularStyleDefault,
                  ),
                  icon: SvgPicture.asset(AssetImport.bell),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              CustomShadow(
                // aboutTrackbut button
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutTrackbudScreen(),
                      ),
                    );
                  },
                  label: Text(
                    AppTexts.abouTrackBud,
                    style: TextStyles.regularStyleDefault,
                  ),
                  icon: SvgPicture.asset(AssetImport.info),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              CustomShadow(
                // Logout Button
                child: TextButton.icon(
                  onPressed: () {
                    logout();
                  },
                  label: Text(
                    AppTexts.logout,
                    style: TextStyles.regularStyleDefault,
                  ),
                  icon: SvgPicture.asset(AssetImport.logout),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
              Gap(
                CustomPadding.mediumSpace,
              ),
              CustomShadow(
                // delete Account Button
                child: TextButton.icon(
                  onPressed: () {
                    openPopUp();
                  }, //_handleAccountDeletion,
                  label: Text(
                    AppTexts.deleteAcc,
                    style: TextStyle(
                      fontFamily: TextStyles.fontFamily,
                      fontSize: TextStyles.fontSizeDefault,
                      fontWeight: TextStyles.fontWeightDefault,
                      color: CustomColor.red,
                    ),
                  ),
                  icon: SvgPicture.asset(
                    AssetImport.trash,
                    colorFilter: ColorFilter.mode(CustomColor.red, BlendMode.srcIn),
                  ),
                  style: ButtonStyle(
                    alignment: Alignment.centerLeft,
                  ),
                ),
              ),
            ],
          )),
    );
  }
}
