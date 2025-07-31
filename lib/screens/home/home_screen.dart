import 'package:eccmobile/bloc/family_bloc/family_bloc.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/screens/home/family_profile_screen.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/appbar_home.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:loading_overlay/loading_overlay.dart';

import '../../component/app_colors.dart';

class HomeScreen extends StatefulWidget {
  final int currentIndex;
  final FamilyBloc familyBloc;
  final ProfileResponse? profileResponse;
  final bool memberScreen;
  final ScrollController scrollController;

  const HomeScreen(
      {Key? key,
      required this.currentIndex,
      required this.familyBloc,
      this.profileResponse,
      this.memberScreen = false,
      required this.scrollController})
      : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool lastStatus = true;
  bool isShrink = false;

  _scrollListener() {
    isShrink = widget.scrollController.hasClients &&
        widget.scrollController.offset > (120 - kToolbarHeight);

    if (isShrink != lastStatus) {
      setState(() {
        lastStatus = isShrink;
      });
    }
  }

  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    widget.scrollController.removeListener(_scrollListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (isShrink && widget.currentIndex == 0)
          ? AppBarHome.appBarHome(
              context, widget.profileResponse?.name ?? "-", '-',
              //isLoading: (widget.isGuest) ? false : (isProfileLoading || notificationState.isLoading),
              notificationCount: 0,
              onNotificationScreen: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.waxFlower,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Coming Soon'),
                ));
              },
            )
          : null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, addMemberScreen);
        },
        child: Icon(Icons.add, color: AppColors.white),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AppBarHome.appBarHomeWidget(
              context,
              widget.profileResponse?.name ?? "-",
              '-',
              isLoading: false,
              notificationCount: 0,
              onNotificationScreen: () {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: Duration(seconds: 1),
                  backgroundColor: AppColors.waxFlower,
                  behavior: SnackBarBehavior.floating,
                  content: Text('Coming Soon'),
                ));
              },
            ),
            buildBod()
          ],
        ),
      ),
    );
  }

  Widget buildBod() {
    final double defaultHeight = MediaQuery.of(context).size.height / 1.5;
    return CustomScreen(
      marginTop: 100,
      withoutPadding: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: Dimensions.MARGIN_SIZE_LARGE),
          const Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Dimensions.MARGIN_SIZE_LARGE),
            child: Text('List of family', style: robotoBold),
          ),
          const SizedBox(height: Dimensions.PADDING_SIZE_DEFAULT),
          Expanded(
            child: BlocBuilder<FamilyBloc, FamilyState>(
              bloc: widget.familyBloc,
              builder: (context, FamilyState familyState) {
                final Widget defaultWidget = Container(
                  alignment: Alignment.center,
                  height: defaultHeight,
                  child: const Center(child: Text('Family Data Not Found')),
                );

                final Widget loadingWidget = Container(
                  alignment: Alignment.center,
                  height: defaultHeight,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );

                if (familyState is FamilyStateLoading) {
                  return loadingWidget;
                } else {
                  if (familyState is FamilyStateGetList) {
                    return ListView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: Dimensions.PADDING_SIZE_DEFAULT),
                      children: familyState.listFamilyResponse
                          .map((FamilyResponse familyResponse) {
                        return Container(
                          padding: EdgeInsets.symmetric(vertical: 4.h),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, familyProfileScreen,
                                  arguments: {
                                    'familyResponse': familyResponse
                                  });
                            },
                            child: HomeCard(
                              image: familyResponse.photo,
                              name: familyResponse.name,
                              familyrole: familyResponse.familyStatus,
                              birthdate: familyResponse.birthDateFormatted,
                            ),
                          ),
                        );
                      }).toList(),
                    );
                  } else {
                    return defaultWidget;
                  }
                }

                return defaultWidget;
              },
            ),
          ),
        ],
      ),
    );
  }
}

class HomeCard extends StatelessWidget {
  const HomeCard(
      {Key? key,
      required this.image,
      required this.familyrole,
      required this.birthdate,
      required this.name})
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
        leading: ClipOval(
            child: SizedBox.fromSize(
          size: const Size.fromRadius(22),
          child: Image.network(
            image,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.cover,
              );
            },
          ),
        )),
        title: Padding(
          padding: EdgeInsets.only(top: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 15.sp),
                  ),
                  SizedBox(
                    height: 3.h,
                  ),
                  Text(
                    familyrole,
                    style: TextStyle(
                        color: AppColors.cadmiumOrange, fontSize: 11.sp),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    birthdate,
                    style: TextStyle(color: Colors.grey, fontSize: 11.sp),
                  ),
                  SizedBox(
                    height: 10.h,
                  )
                ],
              ),
              const Icon(
                Icons.arrow_forward_ios_sharp,
                size: 12,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
