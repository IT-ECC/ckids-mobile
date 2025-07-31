import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/resource/dimensions.dart';
import 'package:flutter/material.dart';

class CustomScreen extends StatelessWidget {
  final Widget child;
  final bool withoutPadding;
  final double marginTop;

  CustomScreen({required this.child, this.withoutPadding = false, this.marginTop = 50});

  @override
  Widget build(BuildContext context) {
    final double defaultHeight = MediaQuery.of(context).size.height / 1.38;

    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: marginTop),
      decoration: BoxDecoration(
        color: AppColors.whiteSmoke,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 2,
            blurRadius: 7,
            offset: Offset(0, 0), // changes position of shadow
          ),
        ]
      ),
      padding: (withoutPadding) ? const EdgeInsets.all(0) : const EdgeInsets.all(Dimensions.PADDING_SIZE_LARGE),//(!withoutPadding) ? const EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_LARGE) : const EdgeInsets.all(0),
      child: child,
    );
  }
}
