import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:flutter/material.dart';

class MenuTile extends StatelessWidget {
  final String title;
  final GestureTapCallback? onTap;
  final IconData? icon;

  MenuTile({
    required this.title,
    required this.onTap,
    this.icon
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            if (icon != null) Padding(
              padding: const EdgeInsets.only(right: Dimensions.PADDING_SIZE_DEFAULT),
              child: Icon(icon),
            ),
            Expanded(
              child: Text(title, style: robotoRegular.copyWith(color: AppColors.black)),
            ),
            const Icon(Icons.chevron_right)
          ],
        ),
      ),
    );
  }
}
