import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_colors.dart';

class DefaultButton extends StatelessWidget {
  DefaultButton({
    required this.text,
    required this.press,
    this.height = 49,
    this.isCard = false,
    Key? key,
  }) : super(key: key);

  double height;
  bool? isCard;
  final String text;
  final GestureTapCallback? press;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: press,
        child: Container(
          width: double.maxFinite,
          height: 49.h,
          margin: EdgeInsets.only(
            left: isCard == true ? 31.w : 61.w,
            right: isCard == true ? 31.w : 61.w,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: (press == null) ? Color(0xFFF58220).withOpacity(0.2) : AppColors.cadmiumOrange
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 20.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
