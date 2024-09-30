import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:track_bud/models/user_model.dart';
import 'package:track_bud/services/firestore_service.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';

/// Widget for displaying and managing equal splits among group members.
class EqualGroupSplitWidget extends StatefulWidget {
  final double amount;
  final List<String> members;
  final Function(List<String>) onMembersSelected;

  const EqualGroupSplitWidget({super.key, required this.amount, required this.members, required this.onMembersSelected});

  @override
  State<EqualGroupSplitWidget> createState() => _EqualGroupSplitWidgetState();
}

class _EqualGroupSplitWidgetState extends State<EqualGroupSplitWidget> {
  List<UserModel> _memberData = []; // List to store data for each group member.
  List<String> _selectedMembers = []; // List of IDs of currently selected members.

  @override
  void initState() {
    super.initState();
    // Initiates fetching of member data.
    _fetchMembers();
    // Populate _selectedMembers with all member IDs initially.
    _selectedMembers = List.from(widget.members);
  }

  // Asynchronously fetches member data from Firestore.
  Future<void> _fetchMembers() async {
    List<UserModel> membersData = []; // Temporary list to store fetched user data.
    for (String memberId in widget.members) {
      UserModel? userModel = await FirestoreService().getUser(memberId); // Retrieve user data by ID.
      if (userModel != null) {
        membersData.add(userModel); // Add successfully retrieved user data to the list.
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
    final defaultColorScheme = Theme.of(context).colorScheme; // Retrieve the current theme's color scheme.

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
  Widget _buildMemberTile(UserModel member, String memberId, ColorScheme colorScheme) {
    bool isSelected = _selectedMembers.contains(memberId); // Check if the member is currently selected.
    double individualAmount = _selectedMembers.isNotEmpty
        ? widget.amount / _selectedMembers.length // Calculate each member's share.
        : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
      child: CustomShadow(
        child: Container(
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.surface : colorScheme.onSurface,
            borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: CustomPadding.defaultSpace, vertical: CustomPadding.defaultSpace),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(Constants.roundedCorners),
              child: SizedBox(
                width: Constants.addGroupPPSize,
                height: Constants.addGroupPPSize,
                child: member.profilePictureUrl.isNotEmpty
                    ? Image.network(member.profilePictureUrl, fit: BoxFit.cover)
                    : const Icon(Icons.person, size: 30),
              ),
            ),
            // member name
            title: Text(member.name, style: TextStyles.regularStyleDefault.copyWith(color: colorScheme.primary)),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isSelected)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(Constants.contentBorderRadius),
                        border: Border.all(color: colorScheme.outline)),
                    // Show each member's share
                    child: Text('${individualAmount.toStringAsFixed(2)}€',
                        style: TextStyles.hintStyleDefault.copyWith(color: colorScheme.secondary)),
                  ),
                const Gap(10),
                Switch(
                  activeColor: CustomColor.bluePrimary,
                  value: isSelected,
                  onChanged: (bool value) {
                    setState(() {
                      if (value) {
                        _selectedMembers.add(memberId); // Add member ID if the switch is turned on.
                      } else {
                        _selectedMembers.remove(memberId); // Remove member ID if the switch is turned off.
                      }
                      widget.onMembersSelected(_selectedMembers); // Callback to update the selected members list.
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
