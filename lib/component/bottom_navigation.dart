import 'package:eccmobile/contoh/pages/covid-page.dart';
import 'package:eccmobile/screens/example/holiday_screen.dart';
import 'package:eccmobile/screens/example/joke_screen.dart';
import 'package:eccmobile/screens/home/home_screen.dart';
import 'package:eccmobile/screens/member/add_member_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../screens/event/event_screen.dart';
import '../screens/member/member_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/ticket/ticket_screen.dart';

class BottomBar extends StatelessWidget {
  BottomBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      context,
      screens: _buildScreens(),
      items: _navbarItems(),
      navBarStyle: NavBarStyle.style6,
    );
  }

  List<Widget> _buildScreens() {
    return [
      // HomeScreen(),
      // EventScreen(),
      // TicketScreen(),
      // MemberScreen(),
      // ProfileScreen(),
    ];
  }

  List<PersistentBottomNavBarItem> _navbarItems() {
    return [
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/home.png'), size: 30.h),
        title: ("Home"),
        textStyle: TextStyle(fontSize: 9.sp),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Color(0xFFF58220),
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(
          AssetImage('assets/icons/calender.png'),
          size: 30.h.h,
        ),
        title: ("Event"),
        textStyle: TextStyle(
          fontSize: 9.sp,
        ),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Color(0xFFF58220),
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/ticket.png'), size: 30.h.h),
        title: ("My Ticket"),
        textStyle: TextStyle(fontSize: 9.sp),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Color(0xFFF58220),
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/addMember.png'), size: 30.h.h),
        title: ("Add Member"),
        textStyle: TextStyle(fontSize: 9.sp),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Color(0xFFF58220),
      ),
      PersistentBottomNavBarItem(
        icon: ImageIcon(AssetImage('assets/icons/profile.png'), size: 18.h),
        title: ("Profile"),
        textStyle: TextStyle(
          fontSize: 9.sp,
        ),
        activeColorPrimary: Colors.red,
        inactiveColorPrimary: Color(0xFFF58220),
      ),
    ];
  }
}
