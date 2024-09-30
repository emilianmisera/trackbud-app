import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/group_model.dart';
import 'package:track_bud/models/group_split_model.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/all_group_debts_screen.dart';
import 'package:track_bud/utils/debts/group/chart/group_transaction_overview.dart';
import 'package:track_bud/utils/debts/group/group_debts_overview.dart';
import 'package:track_bud/utils/enum/categories.dart';
import 'package:track_bud/utils/plus_button/split/add_group_split.dart';
import 'package:track_bud/utils/tiles/information_tiles.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/tiles/split/group_split_tile.dart';

class GroupOverviewScreen extends StatefulWidget {
  final String groupId; // Identifier for the group
  final String groupName; // Name of the group

  const GroupOverviewScreen({
    super.key,
    required this.groupId,
    required this.groupName,
  });

  @override
  State<GroupOverviewScreen> createState() => _GroupOverviewScreenState();
}

class _GroupOverviewScreenState extends State<GroupOverviewScreen> {
  final FirestoreService _firestoreService = FirestoreService(); // Service to interact with Firestore
  late Future<GroupModel> _groupFuture; // Future to hold the fetched group data

  @override
  void initState() {
    super.initState();
    // Initialize the future to fetch group data
    _groupFuture = _firestoreService.getGroup(widget.groupId);
    // Refresh group data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _refreshGroupData();
    });
  }

  // Method to refresh the group's data
  Future<void> _refreshGroupData() async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await groupProvider.refreshGroupData(widget.groupId); // Refresh group data in provider
    groupProvider.invalidateDebtsOverviewCache(widget.groupId); // Invalidate cache for debts overview
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context).colorScheme; // Get the current theme's color scheme
    final currentUserId = Provider.of<UserProvider>(context, listen: false).currentUser?.userId ?? ''; // Get current user ID
    final groupProvider = Provider.of<GroupProvider>(context); // Access group provider

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.groupName,
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
        ),
        centerTitle: true, // Center the title
      ),
      body: FutureBuilder<GroupModel>(
        future: _groupFuture, // Await group data
        builder: (context, snapshot) {
          // Handle different states of the future
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Show loading indicator
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: defaultColorScheme.primary),
              ),
            ); // Show error message
          } else if (!snapshot.hasData) {
            return Center(
              child: Text(
                'No group data available',
                style: TextStyle(color: defaultColorScheme.primary),
              ),
            ); // Show message if no data
          }

          final currentGroup = snapshot.data!; // Get the fetched group data

          return StreamBuilder<QuerySnapshot<GroupSplitModel>>(
            stream: _firestoreService.getGroupSplitsStream(widget.groupId), // Listen for group splits
            builder: (context, snapshot) {
              // Handle different states of the stream
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator()); // Show loading indicator
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(color: defaultColorScheme.primary),
                  ),
                ); // Show error message
              } else {
                // Convert snapshot data into a list of GroupSplitModel
                List<GroupSplitModel> splits = snapshot.data?.docs.map((doc) => doc.data()).toList() ?? [];

                // Calculate expenses and credits for the current user
                double currentUserExpenses = groupProvider.getCurrentUserExpenses(widget.groupId);
                double totalGroupExpense = groupProvider.getGroupExpense(widget.groupId);
                double currentUserCredit = groupProvider.getUserCredit(widget.groupId);
                double expensesPerPerson =
                    currentGroup.members.isNotEmpty ? totalGroupExpense / currentGroup.members.length : 0; // Calculate expenses per member

                Map<Categories, double> categoryAmounts = groupProvider.getCategoryAmounts(widget.groupId);

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(CustomPadding.defaultSpace),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display overall group expense
                        InfoTile(
                          title: '${AppTexts.overallExpenses} (${expensesPerPerson.toStringAsFixed(2)}€/Person)',
                          amount: totalGroupExpense.toStringAsFixed(2),
                          color: defaultColorScheme.primary,
                        ),
                        const Gap(CustomPadding.mediumSpace),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Display current user's expenses
                            InfoTile(
                              title: AppTexts.myExpenses,
                              amount: currentUserExpenses.toStringAsFixed(2),
                              color: CustomColor.bluePrimary,
                              width: MediaQuery.of(context).size.width / 2 - Constants.infoTileSpace,
                            ),
                            // Display current user's credits or debts
                            InfoTile(
                              title: currentUserCredit >= 0 ? AppTexts.credits : AppTexts.debts,
                              amount: currentUserCredit.abs().toStringAsFixed(2),
                              color: currentUserCredit > 0
                                  ? CustomColor.green
                                  : currentUserCredit < 0
                                      ? CustomColor.red
                                      : defaultColorScheme.secondary,
                              width: MediaQuery.of(context).size.width / 2 - Constants.infoTileSpace,
                            ),
                          ],
                        ),
                        const Gap(CustomPadding.defaultSpace),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Section header for debts overview
                            Text(
                              AppTexts.debtsOverview,
                              style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                            ),
                            // Button to navigate to all debts screen
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AllDebtsScreen(
                                            groupId: widget.groupId,
                                          )),
                                );
                              },
                              child: Text(
                                AppTexts.showAll,
                                style: TextStyles.regularStyleMedium.copyWith(color: CustomColor.bluePrimary),
                              ),
                            ),
                          ],
                        ),
                        const Gap(CustomPadding.mediumSpace),
                        // Display debts overview using a FutureBuilder
                        Consumer<GroupProvider>(
                          builder: (context, groupProvider, child) {
                            return FutureBuilder<List<Map<String, dynamic>>>(
                              future: groupProvider.getGroupDebtsOverview(widget.groupId),
                              builder: (context, snapshot) {
                                // Handle different states of the future
                                if (snapshot.connectionState == ConnectionState.waiting) {
                                  return const CircularProgressIndicator(); // Show loading indicator
                                } else if (snapshot.hasError) {
                                  return Text(
                                    'Error: ${snapshot.error}',
                                    style: TextStyle(color: defaultColorScheme.primary),
                                  ); // Show error message
                                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                  return Text(
                                    'No debts to display',
                                    style: TextStyle(color: defaultColorScheme.primary),
                                  ); // Show message if no debts
                                }

                                return DebtsOverview(groupId: widget.groupId); // Display debts overview
                              },
                            );
                          },
                        ),
                        const Gap(CustomPadding.defaultSpace),
                        // Section header for transaction overview
                        Text(
                          AppTexts.transactionOverview,
                          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                        ),
                        const Gap(CustomPadding.mediumSpace),
                        // Display transaction overview with hardcoded category amounts
                         TransactionOverview(
                          categoryAmounts: categoryAmounts,
                        ),
                        const Gap(CustomPadding.defaultSpace),
                        // Section header for history of splits
                        Text(
                          AppTexts.history,
                          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                        ),
                        const Gap(CustomPadding.mediumSpace),
                        // Display a list of group splits
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(), // Prevent scrolling
                          itemCount: splits.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: CustomPadding.mediumSpace),
                              child: GroupSplitTile(
                                split: splits[index], // Individual split details
                                currentUserId: currentUserId, // Pass current user ID for reference
                              ),
                            );
                          },
                        ),
                        // Add space at the bottom of the screen
                        SizedBox(
                          height: MediaQuery.of(context).size.height * CustomPadding.bottomSpace + CustomPadding.bigbigSpace,
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          );
        },
      ),
      bottomSheet: FutureBuilder<GroupModel>(
        future: _groupFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const SizedBox.shrink(); // Hide if no data is available
          final currentGroup = snapshot.data!; // Get the current group data

          return Container(
            color: defaultColorScheme.onSurface, // Set background color for bottom sheet
            child: Container(
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * CustomPadding.bottomSpace,
                left: CustomPadding.defaultSpace,
                right: CustomPadding.defaultSpace,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  // Fetch member names for the modal dialog
                  List<String> memberNames = await Future.wait(
                    currentGroup.members
                        .map((memberId) => _firestoreService.getUser(memberId))
                        .map((futureUser) => futureUser.then((user) => user?.name ?? 'Unknown')),
                  );

                  if (context.mounted) {
                    // Show modal bottom sheet to add a group split
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => AddGroupSplit(
                        selectedGroup: currentGroup, // Pass the current group to the modal
                        memberNames: memberNames, // Pass member names to the modal
                        currentUserId: currentUserId, // Pass current user ID
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: CustomColor.bluePrimary, // Set button color
                ),
                child: Text(AppTexts.addDebt), // Button text
              ),
            ),
          );
        },
      ),
    );
  }
}
