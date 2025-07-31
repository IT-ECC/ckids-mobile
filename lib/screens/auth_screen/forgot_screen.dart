import 'package:eccmobile/component/default_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/app_colors.dart';

class ForgotScreen extends StatefulWidget {
  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Center(
                child: Container(
                    margin: EdgeInsets.only(top: 76.h, right: 51.w, left: 52.w),
                    height: 325.h,
                    width: 325.w,
                    child: Image.asset('assets/images/logo.png')),
              ),
              Text(
                'Forgot password?',
                style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 23.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: TextFormField(
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                          color: AppColors.cadmiumOrange, width: 0.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                      borderSide: BorderSide(
                          color: AppColors.cadmiumOrange, width: 0.0),
                    ),
                    labelText: 'Username/Email',
                  ),
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              DefaultButton(
                text: 'Submit',
                press: () {},
              ),
              SizedBox(
                height: 10.h,
              ),
              InkWell(
                  onTap: () {},
                  child: Text(
                    "Need Help?",
                    style: TextStyle(
                        color: AppColors.cadmiumOrange, fontSize: 15.sp),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
