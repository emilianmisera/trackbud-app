import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:track_bud/utils/constants.dart';
import 'package:track_bud/utils/shadow.dart';
import 'package:track_bud/utils/strings.dart';

class GroupTile extends StatefulWidget {
  const GroupTile({
    super.key,
    required TextEditingController createGroupController,
    required this.onImageSelected, // Add this line to accept the callback
  }) : _createGroupController = createGroupController;

  final TextEditingController _createGroupController;
  final Function(File?) onImageSelected; // Define the callback

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
        widget.onImageSelected(_image); // Pass the image back to parent widget
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: getImage,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100.0),
            child: Container(
              width: 60,
              height: 60,
              color: _image != null ? null : Colors.grey,
              child: _image != null
                  ? Image.file(_image!, fit: BoxFit.cover)
                  : const Icon(Icons.groups, color: Colors.white),
            ),
          ),
        ),
        const Gap(CustomPadding.mediumSpace),
        Expanded(
          child: CustomShadow(
            child: SizedBox(
              height: Constants.height,
              child: TextFormField(
                controller: widget._createGroupController,
                cursorColor: CustomColor.bluePrimary,
                decoration: InputDecoration(
                  hintText: AppTexts.groupNameHint,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: CustomPadding.defaultSpace,
                    vertical: CustomPadding.contentHeightSpace,
                  ),
                  hintStyle: TextStyles.hintStyleDefault,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  filled: true,
                  fillColor: CustomColor.white,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius:
                        BorderRadius.circular(Constants.contentBorderRadius),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
