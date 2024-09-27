import 'package:flutter/material.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

// Widget for displaying and managing equal splits among group members.
class EqualGroupSplitWidget extends StatefulWidget {
  final double amount; // Total amount to be split among members.
  final List<String> members; // List of all member IDs in the group.
  final Function(List<String>)
      onMembersSelected; // Callback for handling selected members.

  const EqualGroupSplitWidget({
    Key? key,
    required this.amount,
    required this.members,
    required this.onMembersSelected,
  }) : super(key: key);

  @override
  State<EqualGroupSplitWidget> createState() => _EqualGroupSplitWidgetState();
}

class _EqualGroupSplitWidgetState extends State<EqualGroupSplitWidget> {
  List<UserModel> _memberData = []; // List to store data for each group member.
  List<String> _selectedMembers =
      []; // List of IDs of currently selected members.

  @override
  void initState() {
    super.initState();
    _fetchMembers(); // Initiates fetching of member data.
    // Populate _selectedMembers with all member IDs initially.
    _selectedMembers = List.from(widget.members);
  }

  // Asynchronously fetches member data from Firestore.
  Future<void> _fetchMembers() async {
    List<UserModel> membersData =
        []; // Temporary list to store fetched user data.
    for (String memberId in widget.members) {
      UserModel? userModel = await FirestoreService()
          .getUser(memberId); // Retrieve user data by ID.
      if (userModel != null) {
        membersData.add(
            userModel); // Add successfully retrieved user data to the list.
      }
    }
    setState(() {
      _memberData = membersData; // Update the state with fetched member data.
    });
    // Invoke the callback to ensure all members are selected after data fetching.
    widget.onMembersSelected(_selectedMembers);
  }

  @override
  Widget build(BuildContext context) {
    final defaultColorScheme = Theme.of(context)
        .colorScheme; // Retrieve the current theme's color scheme.

    return Column(
      children: [
        if (_memberData.isEmpty)
          const CircularProgressIndicator() // Display a loading indicator while data is being fetched.
        else
          ..._memberData.map(
            (member) => _buildMemberTile(
              member,
              member.userId,
              defaultColorScheme, // Create a tile for each group member.
            ),
          ),
      ],
    );
  }

  // Builds a tile for each group member displaying their name and selection switch.
  Widget _buildMemberTile(
      UserModel member, String memberId, ColorScheme colorScheme) {
    bool isSelected = _selectedMembers
        .contains(memberId); // Check if the member is currently selected.
    double individualAmount = _selectedMembers.isNotEmpty
        ? widget.amount /
            _selectedMembers.length // Calculate each member's share.
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(
          vertical: 4.0), // Add vertical padding for spacing.
      child: CustomShadow(
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? colorScheme
                    .outline // Change background color based on selection status.
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(
                Constants.contentBorderRadius), // Rounded corners for the tile.
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(
              horizontal: CustomPadding.defaultSpace,
              vertical: CustomPadding.defaultSpace,
            ),
            leading: ClipRRect(
              borderRadius:
                  BorderRadius.circular(100.0), // Circular profile picture.
              child: SizedBox(
                width: 40,
                height: 40,
                child: member.profilePictureUrl.isNotEmpty
                    ? Image.network(member.profilePictureUrl,
                        fit: BoxFit.cover) // Load member's profile picture.
                    : const Icon(Icons.person,
                        size: 30), // Default icon if no picture is available.
              ),
            ),
            title: Text(
              member.name,
              style: TextStyles.regularStyleDefault.copyWith(
                  color: colorScheme.primary), // Display member's name.
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(
                        10), // Padding around the share amount display.
                    decoration: BoxDecoration(
                      color: colorScheme
                          .surface, // Background color for the share amount.
                      borderRadius: BorderRadius.circular(
                          Constants.contentBorderRadius), // Rounded corners.
                      border: Border.all(
                          color:
                              colorScheme.outline), // Border for the container.
                    ),
                    child: Text(
                      '${individualAmount.toStringAsFixed(2)}€', // Show each member's share formatted to 2 decimal places.
                      style: TextStyles.hintStyleDefault.copyWith(
                          color: colorScheme
                              .secondary), // Style for the share amount text.
                    ),
                  ),
                const SizedBox(
                    width:
                        10), // Space between the share amount and the switch.
                Switch(
                  activeColor: CustomColor
                      .bluePrimary, // Color for the active state of the switch.
                  value:
                      isSelected, // Current value of the switch (selected or not).
                  onChanged: (bool value) {
                    setState(() {
                      if (value) {
                        _selectedMembers.add(
                            memberId); // Add member ID if the switch is turned on.
                      } else {
                        _selectedMembers.remove(
                            memberId); // Remove member ID if the switch is turned off.
                      }
                      widget.onMembersSelected(
                          _selectedMembers); // Callback to update the selected members list.
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
