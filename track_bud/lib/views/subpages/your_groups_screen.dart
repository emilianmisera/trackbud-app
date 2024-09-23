import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:track_bud/provider/group_provider.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/debts/group/create_group/create_group_sheet.dart';
import 'package:track_bud/utils/debts/group/group_card.dart';
import 'package:track_bud/utils/strings.dart';
import 'package:track_bud/utils/textfields/searchfield.dart';

class YourGroupsScreen extends StatefulWidget {
  const YourGroupsScreen({super.key});

  @override
  State<YourGroupsScreen> createState() => _YourGroupsScreenState();
}

class _YourGroupsScreenState extends State<YourGroupsScreen> {
  final TextEditingController _searchController = TextEditingController();

  List groupList = [];

  void _searchGroup(String query) {
    //TODO: add search-function
    // https://youtu.be/ZHdg2kfKmjI?si=ufWetKZ8HdE6OyjQ&t=49
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGroups();
    });
  }

  Future<void> _loadGroups() async {
    final groupProvider = Provider.of<GroupProvider>(context, listen: false);
    await groupProvider.loadGroups();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppTexts.yourGroups, style: TextStyles.regularStyleMedium),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => showModalBottomSheet(context: context, builder: (context) => const CreateGroupSheet()),
            icon: const Icon(
              Icons.add,
              color: CustomColor.bluePrimary,
              size: 30,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          // spacing between content and screen
          padding:
              const EdgeInsets.only(top: CustomPadding.defaultSpace, left: CustomPadding.defaultSpace, right: CustomPadding.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //SearchField
              SearchTextfield(
                hintText: AppTexts.search,
                controller: _searchController,
                onChanged: _searchGroup,
              ),
              const Gap(CustomPadding.defaultSpace),
              // List of Groups (using Consumer)
              Consumer<GroupProvider>(
                builder: (context, groupProvider, child) {
                  if (groupProvider.isLoading) {
                    return const Center(child: CircularProgressIndicator(color: CustomColor.bluePrimary));
                  } else if (groupProvider.groups.isEmpty) {
                    return const Center(child: Text("Keine Gruppen gefunden."));
                  } else {
                    return Column(
                      children: groupProvider.groups
                          .map((group) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: CustomPadding.smallSpace),
                                child: GroupCard(group: group),
                              ))
                          .toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
