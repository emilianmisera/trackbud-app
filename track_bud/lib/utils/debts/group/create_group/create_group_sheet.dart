import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/create_group/grouptile.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:uuid/uuid.dart';

class CreateGroupSheet extends StatefulWidget {
  const CreateGroupSheet({super.key});

  @override
  State<CreateGroupSheet> createState() => _CreateGroupSheetState();
}

class _CreateGroupSheetState extends State<CreateGroupSheet> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<String> _selectedFriends = [];
  File? _selectedImage; // Store the image

  void _createGroup(BuildContext context) async {
    if (_groupNameController.text.isEmpty || _selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Bitte Gruppennamen eingeben und mindestens einen Freund auswählen')),
      );
      return;
    }

    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser!;

    List<String> groupMembers = [
      currentUser.uid,
      ..._selectedFriends.where((id) => id.isNotEmpty)
    ];

    var uuid = const Uuid();
    String groupId = uuid.v4();

    GroupModel newGroup = GroupModel(
      groupId: groupId,
      name: _groupNameController.text,
      profilePictureUrl: '',
      members: groupMembers,
      createdBy: currentUser.uid,
      createdAt: DateTime.now().toIso8601String(),
    );

    // Pass the image file along with the group creation
    await groupProvider.createGroup(newGroup, _selectedImage);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          MediaQuery.sizeOf(context).height * Constants.modalBottomSheetHeight,
      width: MediaQuery.sizeOf(context).width,
      decoration: BoxDecoration(
          color: CustomColor.backgroundPrimary,
          borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
      child: Padding(
        padding: const EdgeInsets.only(
            left: CustomPadding.defaultSpace,
            right: CustomPadding.defaultSpace,
            bottom: 50),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Gap(CustomPadding.mediumSpace),
            Center(
              child:
                  // grabber
                  Container(
                width: 36,
                height: 5,
                decoration: const BoxDecoration(
                    color: CustomColor.grabberColor,
                    borderRadius: BorderRadius.all(Radius.circular(100))),
              ),
            ),
            const Gap(CustomPadding.defaultSpace),
            Center(
              child:
                  Text(AppTexts.addGroup, style: TextStyles.regularStyleMedium),
            ),
            const Gap(CustomPadding.mediumSpace),
            // Pass the callback to handle image selection
            GroupTile(
              createGroupController: _groupNameController,
              onImageSelected: (File? image) {
                setState(() {
                  _selectedImage = image; // Store the selected image
                });
              },
            ),
            const Gap(CustomPadding.defaultSpace),
            Text(AppTexts.addMembers, style: TextStyles.regularStyleMedium),
            const Gap(CustomPadding.mediumSpace),
            Expanded(
              child: FutureBuilder<List<UserModel>>(
                future: FirestoreService()
                    .getFriends(FirebaseAuth.instance.currentUser!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Spacer();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      UserModel friend = snapshot.data![index];
                      String friendId = friend.userId.isNotEmpty
                          ? friend.userId
                          : 'user_$index';

                      debugPrint(
                          'Friend data: ${friend.toMap()}'); // Debug print entire friend object

                      return CheckboxListTile(
                        title: Text(friend.name),
                        secondary: ClipRRect(
                          borderRadius: BorderRadius.circular(100.0),
                          child: SizedBox(
                            width: 40,
                            height: 40,
                            child: friend.profilePictureUrl != ""
                                ? Image.network(friend.profilePictureUrl,
                                    fit: BoxFit.cover)
                                : const Icon(Icons.person, color: Colors.grey),
                          ),
                        ),
                        value: _selectedFriends.contains(friendId),
                        onChanged: (bool? value) {
                          setState(() {
                            debugPrint(
                                'Checkbox changed for friend: $friendId');
                            if (value != null && value) {
                              _selectedFriends.add(friendId);
                              debugPrint('Added friend: $friendId');
                            } else {
                              _selectedFriends.remove(friendId);
                              debugPrint('Removed friend: $friendId');
                            }
                            debugPrint('Selected friends: $_selectedFriends');
                          });
                        },
                      );
                    },
                  );
                },
              ),
            ),
            const Spacer(),
            ElevatedButton(
                onPressed: () => _createGroup(context),
                child: Text(AppTexts.addGroup)),
          ],
        ),
      ),
    );
  }
}
