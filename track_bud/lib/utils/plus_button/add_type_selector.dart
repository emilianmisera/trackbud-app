import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/plus_button/split/add_friend_split.dart';
import 'package:track_bud/utils/plus_button/add_transaction.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/group_choice.dart';
import 'package:track_bud/utils/debts/friend/friend_choice.dart';
import 'package:track_bud/utils/plus_button/split/add_group_split.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/models/user_model.dart';

class AddTypeSelector extends StatefulWidget {
  const AddTypeSelector({super.key});

  @override
  State<AddTypeSelector> createState() => _AddTypeSelectorState();
}

class _AddTypeSelectorState extends State<AddTypeSelector> {
  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadGroups();
  }

  Future<void> _loadUserData() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.loadCurrentUser();
  }

  Future<void> _loadGroups() async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await groupProvider
        .loadGroups(); // Assume this method exists to load groups
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.of(context).size.height * Constants.addBottomSheetHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: CustomColor.backgroundPrimary,
        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
      ),
      child: Padding(
        padding: const EdgeInsets.only(
          left: CustomPadding.defaultSpace,
          right: CustomPadding.defaultSpace,
          bottom: 50,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(CustomPadding.mediumSpace),
            Center(
              child: Container(
                width: 36,
                height: 5,
                decoration: const BoxDecoration(
                  color: CustomColor.grabberColor,
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
            ),
            const Gap(CustomPadding.defaultSpace),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (context) => const AddTransaction(),
                );
              },
              child: Text(AppTexts.addNewTransaction),
            ),
            const Gap(CustomPadding.mediumSpace),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showFriendSelectionDialog(context);
              },
              child: Text(AppTexts.addNewFriendSplit),
            ),
            const Gap(CustomPadding.mediumSpace),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showGroupSelectionDialog(context);
              },
              child: Text(AppTexts.addNewGroupSplit),
            ),
          ],
        ),
      ),
    );
  }

  void _showFriendSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Freund auswählen',
          style: TextStyles.titleStyleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 235,
          child: Consumer<UserProvider>(
            builder: (context, userProvider, child) {
              List<String> friendsIds = userProvider.currentUser?.friends ?? [];

              return FutureBuilder<List<UserModel>>(
                future: Future.wait(
                  friendsIds
                      .map((friendId) => _firestoreService.getUser(friendId)),
                ).then((friends) => friends.whereType<UserModel>().toList()),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final friends = snapshot.data!;
                    return ListView.builder(
                      itemCount: friends.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: FriendChoice(
                            friend: friends[index],
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) => AddFriendSplit(
                                  isGroup: false,
                                  selectedFriend: friends[index],
                                  currentUser: userProvider.currentUser!,
                                ),
                              );
                            },
                          ),
                        );
                      },
                    );
                  }
                },
              );
            },
          ),
        ),
        insetPadding: const EdgeInsets.all(CustomPadding.defaultSpace),
        backgroundColor: CustomColor.backgroundPrimary,
        surfaceTintColor: CustomColor.backgroundPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.contentBorderRadius),
          ),
        ),
      ),
    );
  }

  void _showGroupSelectionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Gruppe auswählen',
          style: TextStyles.titleStyleMedium,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 235,
          child: GroupChoice(
            onGroupSelected: (group) {
              Navigator.pop(context); // Close the dialog
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => AddGroupSplit(
                  isGroup: true,
                  groupId: group.groupId, // Pass the selected group's ID
                ),
              );
            },
          ),
        ),
        insetPadding: const EdgeInsets.all(CustomPadding.defaultSpace),
        backgroundColor: CustomColor.backgroundPrimary,
        surfaceTintColor: CustomColor.backgroundPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(Constants.contentBorderRadius),
          ),
        ),
      ),
    );
  }
}
