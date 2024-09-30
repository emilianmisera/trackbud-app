import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// This Widget is displayed when you want to add a new Split in a Group, you have to select a Group first
class GroupChoice extends StatelessWidget {
  final GroupModel group;
  final void Function(GroupModel, List<String>) onTap;
  final FirestoreService _firestoreService = FirestoreService();

  GroupChoice({super.key, required this.group, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return CustomShadow(
      child: GestureDetector(
        onTap: () async {
          List<String> memberNames = await Future.wait(group.members.map((memberId) async {
            UserModel? user = await _firestoreService.getUser(memberId);
            return user?.name ?? 'Unknown User';
          }));
          onTap(group, memberNames);
        },
        child: CustomShadow(
          child: Container(
            decoration:
                BoxDecoration(borderRadius: BorderRadius.circular(Constants.contentBorderRadius), color: defaultColorScheme.surface),
            padding: const EdgeInsets.all(CustomPadding.mediumSpace),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(Constants.roundedCorners),
                  child: SizedBox(
                    width: Constants.addGroupPPSize,
                    height: Constants.addGroupPPSize,
                    child: group.profilePictureUrl.isNotEmpty
                        ? Image.network(group.profilePictureUrl, fit: BoxFit.cover)
                        : const Icon(Icons.group, color: Colors.grey),
                  ),
                ),
                const Gap(CustomPadding.mediumSpace),
                Expanded(child: Text(group.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary))),
                SizedBox(
                  width: 150,
                  height: 30,
                  child: Stack(
                    children: List.generate(group.members.length, (index) {
                      final reverseIndex = group.members.length - 1 - index;
                      return FutureBuilder<UserModel?>(
                        future: _firestoreService.getUser(group.members[reverseIndex]),
                        builder: (context, snapshot) {
                          return Positioned(
                            right: index * 18,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: defaultColorScheme.surface, width: 1.0),
                                borderRadius: BorderRadius.circular(Constants.roundedCorners),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Constants.roundedCorners),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: snapshot.hasError || snapshot.data == null
                                      ? CircleAvatar(
                                          radius: 15,
                                          backgroundColor: defaultColorScheme.outline,
                                          child: Icon(Icons.person, size: 20, color: defaultColorScheme.secondary),
                                        )
                                      : snapshot.data!.profilePictureUrl.isNotEmpty
                                          ? Image.network(snapshot.data!.profilePictureUrl, fit: BoxFit.cover)
                                          : CircleAvatar(
                                              radius: 15,
                                              backgroundColor: defaultColorScheme.outline,
                                              child: Icon(Icons.person, size: 20, color: defaultColorScheme.secondary),
                                            ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
