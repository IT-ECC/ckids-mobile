import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/screens/member/add_member_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../component/app_colors.dart';

class MemberScreen extends StatelessWidget {
  MemberScreen({Key? key}) : super(key: key);
  final List users = [
    [
      'assets/person/vector.png',
      'Vector Robinson',
      'Ayah',
      '45 thn | 14 Januari 1977'
    ],
    [
      'assets/person/sarah.png',
      'Sarah Robinson',
      'Ibu',
      '43 thn | 14 Maret 1979'
    ],
    [
      'assets/person/henry.png',
      'Henry Robinson',
      'Anak',
      '21 thn | 24 Januari 2001'
    ],
    [
      'assets/person/jessica.png',
      'Jessica Robinson',
      'Anak',
      '15 thn | 13 April 2007'
    ],
    [
      'assets/person/jessica.png',
      'Jessica Robinson',
      'Anak',
      '15 thn | 13 April 2007'
    ],
    [
      'assets/person/jessica.png',
      'Jessica Robinson',
      'Anak',
      '15 thn | 13 April 2007'
    ],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 70.r, left: 24.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/person/johny.png'),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    "Hi, Johny",
                    style:
                        TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 90.h,
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 4,
                itemBuilder: (context, index) => Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 31.h, vertical: 12.w),
                  child: GestureDetector(
                    onTap: () {},
                    child: MemberCard(
                      image: users[index][0],
                      name: users[index][1],
                      familyrole: users[index][2],
                      birthdate: users[index][3],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 35.h,
            ),
          ],
        ),
      ),
    );
  }
}

class MemberCard extends StatelessWidget {
  const MemberCard(
      {Key? key,
      required this.image,
      required this.name,
      required this.familyrole,
      required this.birthdate})
      : super(key: key);

  final String image;
  final String name;
  final String familyrole;
  final String birthdate;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: ListTile(
        leading: CircleAvatar(
          radius: 25.r,
          backgroundImage: AssetImage(image),
          backgroundColor: Colors.transparent,
        ),
        title: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 16.sp),
                  ),
                  Text(
                    familyrole,
                    style:
                        TextStyle(color: AppColors.cadmiumOrange, fontSize: 11.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text(
                    birthdate,
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                  SizedBox(
                    height: 5.h,
                  )
                ],
              ),
              Icon(
                Icons.arrow_forward_ios_sharp,
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
