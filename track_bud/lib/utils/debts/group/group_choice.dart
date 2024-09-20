import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

class GroupChoice extends StatelessWidget {
  final void Function(GroupModel) onGroupSelected;
  final FirestoreService _firestoreService =
      FirestoreService(); // Add FirestoreService

  GroupChoice({super.key, required this.onGroupSelected});

  @override
  Widget build(BuildContext context) {
    return CustomShadow(
      // Keep the CustomShadow for the outer container
      child: Consumer<GroupProvider>(
        builder: (context, groupProvider, child) {
          if (groupProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (groupProvider.groups.isEmpty) {
            return const Center(child: Text("Keine Gruppen gefunden."));
          } else {
            return ListView.builder(
              shrinkWrap: true,
              itemCount: groupProvider.groups.length,
              padding: const EdgeInsets.symmetric(
                horizontal: CustomPadding.defaultSpace,
                vertical: CustomPadding.mediumSpace,
              ), // Apply padding directly to ListView
              itemBuilder: (context, index) {
                final group = groupProvider.groups[index];
                return _buildGroupCard(context, group);
              },
            );
          }
        },
      ),
    );
  }

  // Helper function to build a card for each group
  Widget _buildGroupCard(BuildContext context, GroupModel group) {
    return GestureDetector(
      onTap: () => onGroupSelected(group),
      child: Card(
        color: CustomColor.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Group's profile picture
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: group.profilePictureUrl.isNotEmpty
                      ? Image.network(group.profilePictureUrl,
                          fit: BoxFit.cover)
                      : const Icon(Icons.group, color: Colors.grey),
                ),
              ),
              const Gap(CustomPadding.mediumSpace),
              // Group's name
              Expanded(
                child: Text(group.name, style: TextStyles.regularStyleMedium),
              ),
              // Display member profile pictures
              SizedBox(
                width: 65,
                height: 30,
                child: Stack(
                  children: List.generate(group.members.length, (index) {
                    return FutureBuilder<UserModel?>(
                      future: _firestoreService.getUser(group.members[index]),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox.shrink();
                        }
                        if (snapshot.hasError || snapshot.data == null) {
                          return const Icon(Icons.person, color: Colors.grey);
                        }
                        final member = snapshot.data!;
                        return Positioned(
                          left: index * 18,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: SizedBox(
                              width: 30,
                              height: 30,
                              child: member.profilePictureUrl.isNotEmpty
                                  ? Image.network(member.profilePictureUrl,
                                      fit: BoxFit.cover)
                                  : const Icon(Icons.person,
                                      color: Colors.grey),
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
    );
  }
}
