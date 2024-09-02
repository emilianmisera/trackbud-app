import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/friends_widget.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widgets.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailFriendController = TextEditingController();
  List<UserModel> _friends = [];
  bool _isLoading = true;


  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.sizeOf(context).height *
                  Constants.modalBottomSheetHeight,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: CustomColor.backgroundPrimary,
                borderRadius:
                    BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: CustomPadding.defaultSpace,
                    right: CustomPadding.defaultSpace,
                    bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Gap(CustomPadding.mediumSpace),
                    Center(
                      child: Container(
                        // grabber
                        width: 36,
                        height: 5,
                        decoration: BoxDecoration(
                          color: CustomColor.grabberColor,
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                        ),
                      ),
                    ),
                    Gap(CustomPadding.defaultSpace),
                    Text(
                      AppTexts.addFriend,
                      style: TextStyles.regularStyleMedium,
                    ),
                    Gap(CustomPadding.mediumSpace),
                    CustomTextfield(
                        name: AppTexts.email,
                        hintText: AppTexts.hintEmail,
                        controller: _emailFriendController),
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {},
                        child: Text(AppTexts.addFriend)),
                  ],
                ),
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppTexts.yourFriends,
          style: TextStyles.regularStyleMedium,
        ),
        actions: [
          IconButton(
              onPressed: () {
                _displayBottomSheet(context);
              },
              icon: Icon(
                Icons.add,
                color: CustomColor.bluePrimary,
                size: 30,
              ))
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                // spacing between content and screen
                padding: EdgeInsets.only(
                    top: CustomPadding.defaultSpace,
                    left: CustomPadding.defaultSpace,
                    right: CustomPadding.defaultSpace),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //SearchField
                    SearchTextfield(
                      hintText: AppTexts.search,
                      controller: _searchController,
                      onChanged: (String placeholder){},
                    ),
                    Gap(
                    CustomPadding.defaultSpace,
                    ),
                    // List of Friends
                    if (_friends.isEmpty)
                      Center(child: Text("Keine Freunde gefunden."))
                    else
                      Column(
                        children: _friends
                            .map((friend) => Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: CustomPadding.smallSpace),
                                  child: FriendCard(friend: friend),
                                ))
                            .toList(),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
