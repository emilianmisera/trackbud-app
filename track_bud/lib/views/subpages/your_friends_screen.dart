import 'package:flutter/material.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class YourFriendsScreen extends StatefulWidget {
  const YourFriendsScreen({super.key});

  @override
  State<YourFriendsScreen> createState() => _YourFriendsScreenState();
}

class _YourFriendsScreenState extends State<YourFriendsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _emailFriendController = TextEditingController();
  List friendList = [];

  void _searchFriend(String query) {
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

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
                    BorderRadius.circular(Constants.buttonBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(height: CustomPadding.mediumSpace),
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
                    SizedBox(height: CustomPadding.defaultSpace),
                    Text(AppString.addFriend, style: CustomTextStyle.regularStyleMedium,),
                    SizedBox(height: CustomPadding.mediumSpace),
                    CustomTextfield(name: AppString.email, hintText: AppString.hintEmail, controller: _emailFriendController),
                    Spacer(),
                    ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text(AppString.addFriend)),
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
          AppString.yourFriends,
          style: CustomTextStyle.regularStyleMedium,
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
      body: SingleChildScrollView(
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
                hintText: AppString.search,
                controller: _searchController,
                onChanged: _searchFriend,
              ),
              SizedBox(
                height: CustomPadding.defaultSpace,
              ),
              // List of Friends
              /*
              Expanded(
                child: ListView.builder(
                  itemCount: friendList.length,
                  itemBuilder: (context, index){
                    final friend = friendList[index];
                    return FriendCard();
                  },
                  ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
