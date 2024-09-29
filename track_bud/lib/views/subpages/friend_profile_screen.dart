import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/models/friend_split_model.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/provider/user_provider.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/friend/friend_profile.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/tiles/split/friend_split_tile.dart';

class FriendProfileScreen extends StatefulWidget {
  final UserModel friend; // The friend whose profile is displayed

  const FriendProfileScreen({super.key, required this.friend});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  // Calculates the total debt between the current user and the friend
  Future<double> calculateTotalDebt(String currentUserId, String friendId) async {
    List<FriendSplitModel> splits = await _firestoreService.getFriendSplits(currentUserId, friendId);
    double totalDebt = 0.0;

    // Iterate through each split to determine the total debt
    for (var split in splits) {
      if (split.status == 'pending') {
        if (split.creditorId == currentUserId) {
          totalDebt += split.debtorAmount; // Current user is the creditor
        } else if (split.debtorId == currentUserId) {
          totalDebt -= split.debtorAmount; // Current user is the debtor
        }
      }
    }

    return totalDebt; // Return the total debt amount
  }

  // Builds the profile header, including the friend's profile picture and name
  Widget _buildProfileHeader() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: SizedBox(
          width: Constants.profilePictureAccountEdit,
          height: Constants.profilePictureAccountEdit,
          child: widget.friend.profilePictureUrl != ""
              ? Image.network(widget.friend.profilePictureUrl, fit: BoxFit.cover)
              : const Icon(Icons.person, color: Colors.grey), // Placeholder icon
        ),
      ),
    );
  }

  // Builds the total debt section using a FutureBuilder
  Widget _buildTotalDebtSection(String currentUserId) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<double>(
      future: calculateTotalDebt(currentUserId, widget.friend.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: CustomColor.bluePrimary);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary));
        } else if (!snapshot.hasData) {
          return Text('Keine Daten verfügbar.', style: TextStyle(color: defaultColorScheme.primary));
        } else {
          double totalDebt = snapshot.data!;
          return FriendProfileDetails(totalDebt: totalDebt); // Display total debt
        }
      },
    );
  }

  // Builds the history section of the profile, displaying past splits
  Widget _buildHistorySection(String currentUserId) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<List<FriendSplitModel>>(
      future: _firestoreService.getFriendSplits(currentUserId, widget.friend.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(color: CustomColor.bluePrimary);
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}', style: TextStyle(color: defaultColorScheme.primary));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('Keine Splits gefunden.', style: TextStyle(color: defaultColorScheme.primary));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: CustomPadding.mediumSpace),
                child: FriendSplitTile(
                  split: snapshot.data![index],
                  currentUserId: currentUserId,
                  friendName: widget.friend.name,
                ),
              );
            },
          );
        }
      },
    );
  }

  // Button to pay off debts with the friend
  Widget _buildPayOffDebtsButton(String currentUserId) {
    final defaultColorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(
        bottom: MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
        left: CustomPadding.defaultSpace,
        right: CustomPadding.defaultSpace,
      ),
      child: ElevatedButton(
        onPressed: () async {
          try {
            await _firestoreService.payOffFriendSplits(currentUserId, widget.friend.userId);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text('Schulden mit ${widget.friend.name} wurden beglichen.', style: TextStyle(color: defaultColorScheme.primary))),
            );
            setState(() {}); // Refresh the state
          } catch (e) {
            debugPrint('Error paying off debts: $e');
          }
        },
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: CustomColor.bluePrimary.withOpacity(0.5),
          backgroundColor: CustomColor.bluePrimary,
        ),
        child: Text(AppTexts.payOffDebts),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserId = userProvider.currentUser?.userId ?? '';
    final defaultColorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.friend.name,
          style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            // Use Expanded to take up available space
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(
                  top: CustomPadding.defaultSpace,
                  left: CustomPadding.defaultSpace,
                  right: CustomPadding.defaultSpace,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildProfileHeader(), // Build profile header
                    const Gap(CustomPadding.bigSpace),
                    _buildTotalDebtSection(currentUserId), // Build total debt section
                    const Gap(CustomPadding.defaultSpace),
                    Text(
                      AppTexts.history,
                      style: TextStyles.regularStyleMedium.copyWith(color: defaultColorScheme.primary),
                    ),
                    const Gap(CustomPadding.mediumSpace),
                    _buildHistorySection(currentUserId), // Build history section
                  ],
                ),
              ),
            ),
          ),
          _buildPayOffDebtsButton(currentUserId), // Build pay-off debts button
        ],
      ),
    );
  }
}
