import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
  File? _selectedImage;
  bool _isFormValid = false;

  @override
  void initState() {
    _groupNameController.addListener(_validateForm);
    super.initState();
  }

  void _createGroup(BuildContext context) async {
    final defaultColorScheme = Theme.of(context).colorScheme;
    if (_groupNameController.text.isEmpty || _selectedFriends.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Bitte Gruppennamen eingeben und mindestens einen Freund auswählen',
                style: TextStyles.regularStyleDefault.copyWith(color: defaultColorScheme.primary))),
      );
      return;
    }

    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser!;

    List<String> groupMembers = [currentUser.uid, ..._selectedFriends.where((id) => id.isNotEmpty)];

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

    File? compressedImage = _selectedImage != null ? await compressImage(_selectedImage!) : null;

    await groupProvider.createGroup(newGroup, compressedImage);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }

  Future<File> compressImage(File file) async {
    final filePath = file.absolute.path;
    final lastIndex = filePath.lastIndexOf(RegExp(r'.png|.jpg'));
    final splitName = filePath.substring(0, (lastIndex));
    final outPath = "${splitName}_compressed.jpg";

    var result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      outPath,
      quality: 70,
    );

    return File(result!.path);
  }

  void _validateForm() {
    setState(() {
      _isFormValid = _groupNameController.text.isNotEmpty && _selectedFriends.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return DraggableScrollableSheet(
      initialChildSize: 0.76,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: defaultColorScheme.onSurface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(Constants.contentBorderRadius)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              Center(
                child: Text(AppTexts.createGroup, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace),
                  children: [
                    const Gap(CustomPadding.mediumSpace),
                    GroupTile(
                      createGroupController: _groupNameController,
                      onImageSelected: (File? image) {
                        setState(() {
                          _selectedImage = image;
                        });
                      },
                    ),
                    const Gap(CustomPadding.defaultSpace),
                    Text(AppTexts.addMembers, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                    const Gap(CustomPadding.mediumSpace),
                    FutureBuilder<List<UserModel>>(
                      future: FirestoreService().getFriends(FirebaseAuth.instance.currentUser!.uid),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator(color: CustomColor.bluePrimary));
                        }
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary));
                        }
                        return Column(
                          children: snapshot.data!.map((friend) {
                            String friendId = friend.userId.isNotEmpty ? friend.userId : 'user_${snapshot.data!.indexOf(friend)}';
                            return CheckboxListTile(
                              contentPadding: EdgeInsets.zero,
                              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
                              activeColor: CustomColor.bluePrimary,
                              side: BorderSide(color: defaultColorScheme.secondary, width: 1.5),
                              title: Text(friend.name, style: TextStyle(color: defaultColorScheme.primary)),
                              secondary: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: friend.profilePictureUrl != ""
                                      ? Image.network(friend.profilePictureUrl, fit: BoxFit.cover)
                                      : const Icon(Icons.person, color: Colors.grey),
                                ),
                              ),
                              value: _selectedFriends.contains(friendId),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value != null && value) {
                                    _selectedFriends.add(friendId);
                                  } else {
                                    _selectedFriends.remove(friendId);
                                  }
                                  _validateForm();
                                });
                              },
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: CustomPadding.mediumSpace, vertical: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isFormValid ? () => _createGroup(context) : null,
                    child: Text(AppTexts.createGroup),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
