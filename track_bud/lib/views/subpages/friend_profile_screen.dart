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
  final UserModel friend;
  const FriendProfileScreen({super.key, required this.friend});

  @override
  State<FriendProfileScreen> createState() => _FriendProfileScreenState();
}

class _FriendProfileScreenState extends State<FriendProfileScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  Future<double> calculateTotalDebt(
      String currentUserId, String friendId) async {
    List<FriendSplitModel> splits =
        await _firestoreService.getFriendSplits(currentUserId, friendId);
    double totalDebt = 0.0;

    for (var split in splits) {
      if (split.status == 'pending') {
        if (split.creditorId == currentUserId) {
          totalDebt += split.debtorAmount; // Current user is the creditor
        } else if (split.debtorId == currentUserId) {
          totalDebt -= split.debtorAmount; // Current user is the debtor
        }
      }
    }

    return totalDebt;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final currentUserId = userProvider.currentUser?.userId ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.friend.name,
          style: TextStyles.regularStyleMedium,
        ),
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
                    Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100.0),
                        child: SizedBox(
                          width: Constants.profilePictureAccountEdit,
                          height: Constants.profilePictureAccountEdit,
                          child: widget.friend.profilePictureUrl != ""
                              ? Image.network(widget.friend.profilePictureUrl,
                                  fit: BoxFit.cover)
                              : const Icon(Icons.person, color: Colors.grey),
                        ),
                      ),
                    ),
                    const Gap(CustomPadding.bigSpace),
                    FutureBuilder<double>(
                      future: calculateTotalDebt(
                          currentUserId, widget.friend.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData) {
                          return const Text('Keine Daten verfügbar.');
                        } else {
                          double totalDebt = snapshot.data!;
                          return FriendProfileDetails(totalDebt: totalDebt);
                        }
                      },
                    ),
                    const Gap(CustomPadding.defaultSpace),
                    Text(AppTexts.history,
                        style: TextStyles.regularStyleMedium),
                    const Gap(CustomPadding.mediumSpace),
                    FutureBuilder<List<FriendSplitModel>>(
                      future: _firestoreService.getFriendSplits(
                          currentUserId, widget.friend.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Text('keine Splits gefunden.');
                        } else {
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    bottom: CustomPadding.mediumSpace),
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
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              bottom:
                  MediaQuery.sizeOf(context).height * CustomPadding.bottomSpace,
              left: CustomPadding.defaultSpace,
              right: CustomPadding.defaultSpace,
            ),
            child: ElevatedButton(
              onPressed: () async {
                try {
                  await _firestoreService.payOffFriendSplits(
                      currentUserId, widget.friend.userId);
                  // Optionally, you might want to show a success message to the user.
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            'Schulden mit ${widget.friend.name} wurden beglichen.')),
                  );
                  // You may also want to refresh the state or navigate back, etc.
                  setState(() {}); // Refresh the screen if necessary
                } catch (e) {
                  // Handle any errors (e.g., show an error message)
                  debugPrint('Error paying off debts: $e');
                }
              },
              style: ElevatedButton.styleFrom(
                disabledBackgroundColor:
                    CustomColor.bluePrimary.withOpacity(0.5),
                backgroundColor: CustomColor.bluePrimary,
              ),
              child: Text(AppTexts.payOffDebts),
            ),
          ),
        ],
      ),
    );
  }
}
