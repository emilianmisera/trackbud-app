import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class GroupChoice extends StatelessWidget {
  final GroupModel group;
  final void Function(GroupModel, List<String>) onTap;
  final FirestoreService _firestoreService = FirestoreService();

  GroupChoice({
    super.key,
    required this.group,
    required this.onTap,
  });

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
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
              color: defaultColorScheme.surface,
            ),
            padding: const EdgeInsets.all(CustomPadding.mediumSpace),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.0),
                  child: SizedBox(
                    width: 40,
                    height: 40,
                    child: group.profilePictureUrl.isNotEmpty
                        ? Image.network(group.profilePictureUrl, fit: BoxFit.cover)
                        : const Icon(Icons.group, color: Colors.grey),
                  ),
                ),
                const Gap(CustomPadding.mediumSpace),
                Expanded(
                  child: Text(group.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                ),
                SizedBox(
                  width: 65,
                  height: 30,
                  child: Stack(
                    children: List.generate(group.members.length, (index) {
                      return FutureBuilder<UserModel?>(
                        future: _firestoreService.getUser(group.members[index]),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }
                          if (snapshot.hasError || snapshot.data == null) {
                            return const Icon(Icons.person, color: Colors.grey);
                          }
                          final member = snapshot.data!;
                          return Positioned(
                            left: index * 18,
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: defaultColorScheme.surface, // Weißer Rahmen um das Profilbild
                                  width: 1.0, // Rahmenbreite anpassen
                                ),
                                borderRadius: BorderRadius.circular(100.0), // Rundes Bild
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: member.profilePictureUrl.isNotEmpty
                                      ? Image.network(member.profilePictureUrl, fit: BoxFit.cover)
                                      : const Icon(Icons.person, color: Colors.grey),
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
