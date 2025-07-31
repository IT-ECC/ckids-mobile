import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/bloc/event_bloc/event_bloc.dart';
import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:eccmobile/screens/event/event_screen.dart';
import 'package:eccmobile/screens/home/home_screen.dart';
import 'package:eccmobile/screens/member/member_screen.dart';
import 'package:eccmobile/screens/profile/profile_screen.dart';
import 'package:eccmobile/screens/ticket/ticket_screen.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/custome_animated_bottom_bar.dart';
import 'package:eccmobile/util/widget/my_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MainScreen extends StatefulWidget {
  final int? currentIndex;
  final bool isAdmin;
  const MainScreen({Key? key, this.currentIndex, required this.isAdmin})
      : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final ScrollController _scrollController = ScrollController();
  final _navigatorKey = GlobalKey<NavigatorState>();

  final GlobalKey<ScaffoldState> appBarKeyShowcase = GlobalKey<ScaffoldState>();
  late int _currentIndex;
  late PersistentTabController _controller;
  late bool _hideNavBar;
  bool isShrink = false;

  final sl = GetIt.instance;
  late final AuthBloc authBloc;
  late final EventBloc eventBloc;
  late final FamilyBloc familyBloc;

  @override
  void initState() {
    _currentIndex = widget.currentIndex ?? 0;

    authBloc = sl();
    authBloc.add(AuthEventGetProfile());

    eventBloc = sl();
    eventBloc.add(EventGetUpcoming(isAdmin: widget.isAdmin));

    familyBloc = sl();
    familyBloc.add(FamilyEventGetList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, AuthState authState) {
            if (authState is AuthStateLogoutSuccess) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed(loginScreen);

              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.green,
                content: Text(authState.message),
              ));
            } else if (authState is AuthStateLogoutError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.red,
                content: Text(authState.message),
              ));
            }
          },
        ),
        BlocListener<FamilyBloc, FamilyState>(
          bloc: familyBloc,
          listener: (context, FamilyState familyState) {
            if (familyState is FamilyStateError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                backgroundColor: Colors.red,
                behavior: SnackBarBehavior.floating,
                content: Text(familyState.message),
              ));
            }
          },
        )
      ],
      child: RefreshIndicator(
        onRefresh: () {
          authBloc.add(AuthEventGetProfile());
          eventBloc.add(EventGetUpcoming(isAdmin: widget.isAdmin));
          familyBloc.add(FamilyEventGetList());

          return Future<void>.delayed(const Duration(seconds: 1));
        },
        child: Scaffold(
            bottomNavigationBar: buildBottomNavigationBar(),
            body: SafeArea(
              child: BlocBuilder<AuthBloc, AuthState>(
                bloc: authBloc,
                builder: (context, AuthState authState) {
                  final ProfileResponse? profileResponse =
                      (authState is AuthStateProfile)
                          ? authState.profileResponse
                          : null;

                  return IndexedStack(index: _currentIndex, children: [
                    HomeScreen(
                        currentIndex: _currentIndex,
                        scrollController: _scrollController,
                        familyBloc: familyBloc,
                        profileResponse: profileResponse),
                    EventScreen(eventBloc: eventBloc, isAdmin: widget.isAdmin),
                    if (!widget.isAdmin)
                      TicketScreen(
                        eventBloc: eventBloc,
                        isAdmin: widget.isAdmin,
                      ),
                    // if (widget.isAdmin)
                    // MemberScreen(),
                    ProfileScreen(
                        authBloc: authBloc, profileResponse: profileResponse),
                  ]);
                },
              ),
            )),
      ),
    );
  }

  Widget buildBottomNavigationBar() {
    return CustomAnimatedBottomBar(
      containerHeight: 70,
      backgroundColor: Colors.white,
      selectedIndex: _currentIndex,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      showElevation: true,
      itemCornerRadius: 16,
      curve: Curves.easeIn,
      onItemSelected: (index) {
        if (isShrink && (index != 0)) {
          setState(() => isShrink = false);
        }

        if (index == 0) {
          //_scrollController.animateTo(0, duration: const Duration(milliseconds: 550), curve: Curves.ease);
        }

        setState(() => _currentIndex = index);
      },
      items: <BottomNavyBarItem>[
        BottomNavyBarItem(
          icon: const ImageIcon(AssetImage('assets/icons/home.png')),
          title: Text('Home',
              style: robotoRegular.copyWith(color: AppColors.reddishOrange)),
          activeColor: AppColors.reddishOrange,
          inactiveColor: AppColors.cadmiumOrange,
          textAlign: TextAlign.center,
        ),
        BottomNavyBarItem(
          icon: const ImageIcon(AssetImage('assets/icons/calender.png')),
          title: Text('Event',
              style: robotoRegular.copyWith(color: AppColors.reddishOrange)),
          activeColor: AppColors.reddishOrange,
          inactiveColor: AppColors.cadmiumOrange,
          textAlign: TextAlign.center,
        ),
        if (!widget.isAdmin)
          BottomNavyBarItem(
            icon: const ImageIcon(AssetImage('assets/icons/ticket.png')),
            title: Text('Ticket',
                style: robotoRegular.copyWith(color: AppColors.reddishOrange)),
            activeColor: AppColors.reddishOrange,
            inactiveColor: AppColors.cadmiumOrange,
            textAlign: TextAlign.center,
          ),
        // if (widget.isAdmin)
        //   BottomNavyBarItem(
        //     icon: const ImageIcon(AssetImage('assets/icons/2orang.png'), size: 25),
        //     title: Text('Ecc Kids', style: robotoRegular.copyWith(color: AppColors.reddishOrange)),
        //     activeColor: AppColors.reddishOrange,
        //     inactiveColor: AppColors.cadmiumOrange,
        //     textAlign: TextAlign.center,
        //   ),
        BottomNavyBarItem(
          icon:
              const ImageIcon(AssetImage('assets/icons/profile.png'), size: 20),
          title: Text('Profile',
              style: robotoRegular.copyWith(color: AppColors.reddishOrange)),
          activeColor: AppColors.reddishOrange,
          inactiveColor: AppColors.cadmiumOrange,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
