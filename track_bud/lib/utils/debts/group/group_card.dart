import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/views/subpages/group_overview_screeen.dart';

// This Widget displays a single Group in DebtsScreen or YourGroupScreen
class GroupCard extends StatelessWidget {
  final GroupModel group; // Pass the GroupModel as a parameter

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    // Access the GroupProvider using Provider.of
    final firestoreService = FirestoreService();
    DateTime createdAt = DateTime.parse(group.createdAt);
    String formattedDate = DateFormat.yMd('de_DE').format(createdAt);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => GroupOverviewScreen(
              groupName: group.name,
            ),
          ),
        );
      },
      child: CustomShadow(
          child: Container(
        width: MediaQuery.sizeOf(context).width,
        padding: const EdgeInsets.all(CustomPadding.defaultSpace),
        decoration: BoxDecoration(color: defaultColorScheme.surface, borderRadius: BorderRadius.circular(Constants.contentBorderRadius)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              // Group's profile picture
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: group.profilePictureUrl.isNotEmpty
                      ? Image.network(group.profilePictureUrl, fit: BoxFit.cover)
                      : const Icon(Icons.group, color: Colors.grey),
                ),
              ),
              // Group's name
              title: Text(group.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              // Creation date information
              subtitle: Text('Erstellt am: $formattedDate',
                  style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.secondary)),
              // Placeholder for balance - you'll need to calculate this based on your app's logic
              trailing: Text('0.00€', style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
              minVerticalPadding: 0,
              contentPadding: EdgeInsets.zero,
            ),
            Divider(color: defaultColorScheme.outline),
            const Gap(CustomPadding.mediumSpace),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: Stack(
                      children: List.generate(group.members.length, (index) {
                        // Fetch user data for each member to get their profile picture
                        return FutureBuilder<UserModel?>(
                          future: firestoreService.getUser(group.members[index]),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const SizedBox.shrink(); // Or a placeholder widget while loading
                            }
                            if (snapshot.hasError || snapshot.data == null) {
                              return const Icon(Icons.person, color: Colors.grey); // Error or user not found
                            }
                            final member = snapshot.data!;
                            return Positioned(
                              left: index * 25,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100.0),
                                child: SizedBox(
                                  width: 40,
                                  height: 40,
                                  child: member.profilePictureUrl.isNotEmpty
                                      ? Image.network(member.profilePictureUrl, fit: BoxFit.cover)
                                      : const Icon(Icons.person, color: Colors.grey),
                                ),
                              ),
                            );
                          },
                        );
                      }),
                    ),
                  ),
                ),
                const BalanceState(colorScheme: DebtsColorScheme.blue)
              ],
            ),
          ],
        ),
      )),
    );
  }
}
