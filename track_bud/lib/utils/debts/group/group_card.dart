import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/balance_state.dart';
import 'package:track_bud/utils/enum/debts_box.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/views/subpages/group_overview_screen.dart';

/// A stateless widget to represent a card for a specific group
class GroupCard extends StatelessWidget {
  final GroupModel group;

  const GroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    final firestoreService = FirestoreService();

    // Parsing the group's creation date and formatting it to 'dd/MM/yyyy' format in German locale
    DateTime createdAt = DateTime.parse(group.createdAt);
    String formattedDate = DateFormat.yMd('de_DE').format(createdAt);

    // Fetching group data from GroupProvider (such as total expenses and user credits)
    final groupProvider = Provider.of<GroupProvider>(context);
    final totalExpense = groupProvider.getGroupExpense(group.groupId);
    final userCredit = groupProvider.getUserCredit(group.groupId);

    // Selecting the color scheme based on the user's credit in the group
    DebtsColorScheme colorScheme;
    if (userCredit > 0) {
      colorScheme = DebtsColorScheme.green; // Positive credit (user is owed money)
    } else if (userCredit < 0) {
      colorScheme = DebtsColorScheme.red; // Negative credit (user owes money)
    } else {
      colorScheme = DebtsColorScheme.blue; // Neutral credit (balanced)
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => GroupOverviewScreen(groupName: group.name, groupId: group.groupId)));
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
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(Constants.roundedCorners),
                  child: SizedBox(
                    width: Constants.addGroupPPSize,
                    height: Constants.addGroupPPSize,
                    child: group.profilePictureUrl.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: group.profilePictureUrl,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => const Icon(Icons.group, color: Colors.grey))
                        : const Icon(Icons.group, color: Colors.grey),
                  ),
                ),
                title: Text(group.name, style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                subtitle: Text('Erstellt am: $formattedDate',
                    style: TextStyles.hintStyleDefault.copyWith(fontSize: TextStyles.fontSizeHint, color: defaultColorScheme.secondary)),
                // Displays the total expense in the group
                trailing: Text('${totalExpense.toStringAsFixed(2)}€',
                    style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary)),
                minVerticalPadding: 0,
                contentPadding: EdgeInsets.zero, // Removes default padding
              ),
              Divider(color: defaultColorScheme.outline),
              const Gap(CustomPadding.mediumSpace),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 44,
                      width: 300,
                      child: Stack(
                        children: List.generate(group.members.length, (index) {
                          final reverseIndex = group.members.length - 1 - index;
                          return FutureBuilder<UserModel?>(
                            future: firestoreService.getUser(group.members[reverseIndex]),
                            builder: (context, snapshot) {
                              return Positioned(
                                left: index * 30, // Staggered avatar placement with overlapping
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: defaultColorScheme.surface,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(Constants.roundedCorners),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(Constants.roundedCorners),
                                    child: SizedBox(
                                      width: Constants.addGroupPPSize,
                                      height: Constants.addGroupPPSize,
                                      child: snapshot.hasError || snapshot.data == null
                                          ? CircleAvatar(
                                              radius: 20,
                                              backgroundColor: defaultColorScheme.outline,
                                              child: Icon(Icons.person, size: 30, color: defaultColorScheme.secondary))
                                          : snapshot.data!.profilePictureUrl.isNotEmpty
                                              ? Image.network(snapshot.data!.profilePictureUrl, fit: BoxFit.cover)
                                              : CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: defaultColorScheme.outline,
                                                  child: Icon(Icons.person, size: 30, color: defaultColorScheme.secondary),
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
                  ),
                  // Displays balance state (credit or debit)
                  BalanceState(colorScheme: colorScheme, amount: userCredit == 0 ? null : '${userCredit.abs().toStringAsFixed(2)}€'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
