import 'dart:io';

import 'package:eccmobile/component/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

class SelectedImage extends StatelessWidget {
  final ImagePicker _picker = ImagePicker();
  XFile? imagePicker;

  final ValueChanged<XFile> onChanged;

  SelectedImage({required this.imagePicker, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await _picker.pickImage(source: ImageSource.gallery).then((XFile? value) {
          if (value != null) {
            imagePicker = value;
            onChanged(value);
          }
        });
      },
      child: Container(
        margin: const EdgeInsets.symmetric(
            horizontal: 110, vertical: 10),
        height: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
            const BorderRadius.all(Radius.circular(100)),
            image: (imagePicker != null)
                ? DecorationImage(
                image: FileImage(File(imagePicker!.path)),
                fit: BoxFit.cover)
                : null),
        child: Icon(
          (imagePicker != null)
              ? Icons.edit
              : Icons.photo_library,
          size: 40.h,
          color: (imagePicker != null)
              ? AppColors.cadmiumOrange.withOpacity(0.7)
              : AppColors.cadmiumOrange,
        ),
      ),
    );
  }
}
