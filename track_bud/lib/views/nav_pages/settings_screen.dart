import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/auth/auth_service.dart';
import 'package:track_bud/services/dependency_injector.dart';
import 'package:track_bud/services/sqlite_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';
import 'package:track_bud/views/at_signup/login_screen.dart';
import 'package:track_bud/views/at_signup/onboarding_screen.dart';
import 'package:track_bud/views/subpages/about_trackbud_screen.dart';
import 'package:track_bud/views/subpages/account_settings_screen.dart';
import 'package:track_bud/views/subpages/notifications_settings_screen.dart';
import 'package:track_bud/views/subpages/profile_settings_screen.dart';

class SettingsScreen extends StatefulWidget {
  SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _passwordController = TextEditingController();

  // State variables to hold user info
  String currentUserName = '';
  String currentUserEmail = '';
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    //_loadCurrentUserInfo();
  }

  // SIGNOUT METHOD
  Future<void> _signOut() async {
    try {
      await _authService.signOut();

      // Open LoginScreen on Signout
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      // Show error if Signout fails
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Fehler beim Abmelden: ${e.toString()}'),
        ),
      );
    }
  }

// DELETE USER ACCOUNT (dont delete from firestore DB yet, so friends still see shared costs etc)
  Future<void> _handleAccountDeletion(BuildContext context) async {
    try {
      // Get the password entered by the user
      String password = _passwordController.text;

      // Attempt to delete the user account
      await _authService.deleteUserAccount(password);

      submit();

      // Show success message and navigate away or logout the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Konto erfolgreich gelöscht.')),
      );

      // navigate the user to a login or home screen after deletion
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
      );
    } catch (e) {
      submit();
      // Show error message if something goes wrong
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler beim Löschen des Kontos: $e')),
      );
    }
  }

  Future openPopUp() => showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            AppTexts.deleteAcc,
            style: CustomTextStyle.titleStyleMedium,
          ),
          content: Container(
            width: double.infinity,
            height: 235,
            child: Column(
              children: [
                Text(
                  AppTexts.deleteAccDescribtion,
                  style: CustomTextStyle.hintStyleDefault,
                ),
                SizedBox(
                  height: CustomPadding.defaultSpace,
                ),
                CustomTextfield(
                  name: AppTexts.password,
                  obscureText: true,
                  hintText: AppTexts.hintPassword,
                  controller: _passwordController,
                  autofocus: true,
                ),
                SizedBox(
                  height: CustomPadding.defaultSpace,
                ),
                ElevatedButton(
                  onPressed: () {
                    _handleAccountDeletion(context);
                  },
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
              Radius.circular(Constants.buttonBorderRadius),
            ),
          ),
        ),
      );

  void submit() {
    // hide allert dialog when button is pressed
    _passwordController.clear();
    Navigator.of(context).pop();
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
      print("User ID: $userId");

      UserModel? localUser = await SQLiteService().getUserById(userId);
      print("Local User: ${localUser?.toMap()}");

      await DependencyInjector.syncService.syncData(userId);
      print("Synchronization complete");

      if (localUser != null) {
        setState(() {
          currentUserName = localUser.name;
          currentUserEmail = localUser.email;
          _profileImageUrl = localUser.profilePictureUrl;
        });
      }
    } catch (e, stackTrace) {
      print("Fehler beim Laden der Nutzerdaten: $e");
      print("Stacktrace: $stackTrace");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fehler beim Laden der Nutzerdaten: $e")),
      );
    }
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                Center(
                    child: Text(
                  // FirstName
                  currentUserName,
                  style: CustomTextStyle.titleStyleMedium,
                )),
                SizedBox(
                  height: CustomPadding.smallSpace,
                ),
                Center(
                    child: Text(
                  //email
                  currentUserEmail,
                  style: CustomTextStyle.hintStyleDefault,
                )),
                SizedBox(
                  height: CustomPadding.bigbigSpace,
                ),
                Text(
                  AppTexts.preferences,
                  style: CustomTextStyle.regularStyleMedium,
                ),
                SizedBox(
                  height: CustomPadding.defaultSpace,
                ),
                CustomShadow(
                  // edit Profile Button
                  child: TextButton.icon(
                    onPressed: () async {
                      final shouldReload = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileSettingsScreen(),
                        ),
                      );
                      if (shouldReload == true) {
                        //_loadCurrentUserInfo();
                      }
                    },
                    label: Text(
                      AppTexts.editProfile,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.userEdit),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
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
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.settings),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
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
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.bell),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
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
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.info),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
                ),
                CustomShadow(
                  // Logout Button
                  child: TextButton.icon(
                    onPressed: _signOut,
                    label: Text(
                      AppTexts.logout,
                      style: CustomTextStyle.regularStyleDefault,
                    ),
                    icon: SvgPicture.asset(AssetImport.logout),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
                SizedBox(
                  height: CustomPadding.mediumSpace,
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
                        fontFamily: CustomTextStyle.fontFamily,
                        fontSize: CustomTextStyle.fontSizeDefault,
                        fontWeight: CustomTextStyle.fontWeightDefault,
                        color: CustomColor.red,
                      ),
                    ),
                    icon: SvgPicture.asset(
                      AssetImport.trash,
                      color: CustomColor.red,
                    ),
                    style: ButtonStyle(
                      alignment: Alignment.centerLeft,
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
