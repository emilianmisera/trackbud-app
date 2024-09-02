import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfield_widget.dart';

class YourGroupsScreen extends StatefulWidget {
  const YourGroupsScreen({super.key});

  @override
  State<YourGroupsScreen> createState() => _YourGroupsScreenState();
}

class _YourGroupsScreenState extends State<YourGroupsScreen> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _createGroupController = TextEditingController();
  List groupList = [];

  void _searchGroup(String query) {
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

  Future _displayBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) => Container(
              height: MediaQuery.sizeOf(context).height * Constants.modalBottomSheetHeight,
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(
                color: CustomColor.backgroundPrimary,
                borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace, bottom: 50),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    Center(
                      child: Text(
                        AppTexts.addGroup,
                        style: TextStyles.regularStyleMedium,
                      ),
                    ),
                    Gap(CustomPadding.mediumSpace),
                    GroupTitle(createGroupController: _createGroupController),
                    Gap(CustomPadding.defaultSpace),
                    Text(
                      AppTexts.addMembers,
                      style: TextStyles.regularStyleMedium,
                    ),
                    Gap(CustomPadding.mediumSpace),
                    //TODO: add ListView with Friends
                    Spacer(),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
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
          AppTexts.yourGroups,
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
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding: EdgeInsets.only(top: CustomPadding.defaultSpace, left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SearchField
              SearchTextfield(
                hintText: AppTexts.search,
                controller: _searchController,
                onChanged: _searchGroup,
              ),
              Gap(CustomPadding.defaultSpace),
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

class GroupTitle extends StatelessWidget {
  const GroupTitle({
    super.key,
    required TextEditingController createGroupController,
  }) : _createGroupController = createGroupController;

  final TextEditingController _createGroupController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(100.0),
          child: Container(
            width: 60,
            height: 60,
            color: Colors.red,
          ),
        ),
        Gap(CustomPadding.mediumSpace),
        Expanded(
          child: CustomShadow(
            child: Container(
              height: Constants.height, // choose height of Textfield Box
              child: TextFormField(
                controller: _createGroupController,
                cursorColor: CustomColor.bluePrimary,
                decoration: InputDecoration(
                  hintText: AppTexts.groupNameHint,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.defaultSpace,
                    vertical: CustomPadding.contentHeightSpace,
                  ),
                  hintStyle: TextStyles.hintStyleDefault,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: CustomColor.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
