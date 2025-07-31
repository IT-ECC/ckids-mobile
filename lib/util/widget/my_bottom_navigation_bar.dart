import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyBottomNavigationBar extends StatelessWidget {
  final bool isAdmin;
  final Function(int index) setIndex;
  final int currentIndex;

  MyBottomNavigationBar(
      {required this.setIndex,
      required this.currentIndex,
      required this.isAdmin});

  @override
  Widget build(BuildContext context) {
    final List<BottomNavigationBarItem> listBottomNav = [
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/icons/home.png')),
        label: "Home",
      ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/icons/calender.png')),
        label: "Event",
      ),
      if (!isAdmin)
        const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/ticket.png')),
          label: ("My Ticket"),
        ),
      // if (!isAdmin)
      //   const BottomNavigationBarItem(
      //     icon: ImageIcon(AssetImage('assets/icons/addMember.png')),
      //     label: ("Add Member"),
      //   ),
      if (isAdmin)
        const BottomNavigationBarItem(
          icon: ImageIcon(AssetImage('assets/icons/2orang.png'), size: 25),
          label: ("Ecc Kids"),
        ),
      const BottomNavigationBarItem(
        icon: ImageIcon(AssetImage('assets/icons/profile.png')),
        label: ("Profile"),
      ),
    ];

    return BottomNavigationBar(
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        iconSize: 20.h,
        selectedItemColor: Colors.red,
        unselectedItemColor: const Color(0xFFF58220),
        selectedLabelStyle:
            TextStyle(fontSize: 10, height: 2, color: Colors.black),
        currentIndex: currentIndex,
        onTap: (value) => setIndex(value),
        items: listBottomNav);
  }
}
