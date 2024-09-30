import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/textfields/textfield.dart';

/// This Widget displays a created Group
class GroupTile extends StatefulWidget {
  const GroupTile({super.key, required TextEditingController createGroupController, required this.onImageSelected})
      : _createGroupController = createGroupController;

  final TextEditingController _createGroupController;
  final Function(File?) onImageSelected;

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  File? _image;
  final ImagePicker _picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        widget.onImageSelected(_image);
      } else {
        debugPrint('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: getImage,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Container(
                  width: 60,
                  height: 60,
                  color: _image != null ? null : Colors.grey,
                  child: _image != null ? Image.file(_image!, fit: BoxFit.cover) : const Icon(Icons.groups, color: Colors.white),
                ),
              ),
            ),
            const Gap(CustomPadding.mediumSpace),
            Expanded(child: CustomTextfield(hintText: 'Gruppenname eingeben', controller: widget._createGroupController)),
          ],
        ),
      ],
    );
  }
}
