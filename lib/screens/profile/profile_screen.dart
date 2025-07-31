import 'package:cached_network_image/cached_network_image.dart';
import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/component/default_button.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:eccmobile/screens/profile/edit_profile_screen.dart';
import 'package:eccmobile/screens/screens.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/util/widget/custome_screen.dart';
import 'package:eccmobile/util/widget/menu_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_it/get_it.dart';
import 'package:eccmobile/data/models/response/response.dart';

import '../../component/app_colors.dart';
import '../../component/qr_screen.dart';

// TODO : Implement [Edit Profile, Show Photo User, Biometric Login]

class ProfileScreen extends StatefulWidget {
  final ProfileResponse? profileResponse;
  final AuthBloc authBloc;

  ProfileScreen({Key? key, this.profileResponse, required this.authBloc})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isSwitched = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: SafeArea(
          child: Stack(
            children: [
              Padding(
                padding:
                    const EdgeInsets.only(top: Dimensions.MARGIN_SIZE_LARGE),
                child: Align(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50.0,
                          child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: widget.profileResponse?.photo ?? "-",
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: imageProvider,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              //placeholder: (context, url) => LoadingWidget.loadingRingImage,
                              errorWidget: (context, url, error) {
                                return Container(
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: AssetImage(
                                              'assets/images/logo.png'))),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
                        Text(
                          widget.profileResponse?.name ?? "-",
                          style: robotoBold.copyWith(
                              color: AppColors.white,
                              fontSize: Dimensions.FONT_SIZE_EXTRA_LARGE),
                        ),
                        const SizedBox(
                            height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        Text(
                          widget.profileResponse?.email ?? "-",
                          style: robotoRegularSmall.copyWith(
                              color: AppColors.white),
                        ),
                        const SizedBox(
                            height: Dimensions.MARGIN_SIZE_EXTRA_SMALL),
                        Card(
                          child: QrButton(
                              data: widget.profileResponse?.id ?? "-",
                              size: 170),
                        )
                      ],
                    )),
              ),
              buildBody()
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    final double defaultHeight = MediaQuery.of(context).size.height / 2.38;

    return CustomScreen(
      marginTop: 350,
      withoutPadding: false,
      child: SizedBox(
        height: defaultHeight,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Text('Account Settings',
                    style: robotoRegularSmall.copyWith(
                        fontSize: Dimensions.FONT_SIZE_SMALL,
                        color: AppColors.mountainMist))),
            const SizedBox(height: Dimensions.MARGIN_SIZE_SMALL),
            MenuTile(
                icon: Icons.admin_panel_settings_outlined,
                title: 'Account Security',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: AppColors.waxFlower,
                    behavior: SnackBarBehavior.floating,
                    content: Text('Coming Soon'),
                  ));
                }
            ),
            MenuTile(
                icon: Icons.mark_email_read_outlined,
                title: 'Email Notification Preferences',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 1),
                    backgroundColor: AppColors.waxFlower,
                    behavior: SnackBarBehavior.floating,
                    content: Text('Coming Soon'),
                  ));
                }
            ),
            MenuTile(icon: Icons.info_outline, title: 'About Us', onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 1),
                backgroundColor: AppColors.waxFlower,
                behavior: SnackBarBehavior.floating,
                content: Text('Coming Soon'),
              ));
            }),
            MenuTile(
                icon: Icons.logout,
                title: 'Logout',
                onTap: () {
                  widget.authBloc.add(AuthEventLogout());
                }),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Powered By',
                      style: robotoRegularSmall.copyWith(
                          fontSize: Dimensions.FONT_SIZE_SMALL,
                          color: AppColors.mountainMist)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        child: Image.asset('assets/images/logo_ide.png'),
                        onTap: () {
                          Navigator.pushNamed(context, webViewScreen,
                              arguments: {'url': 'https://www.ide.asia/', 'title': 'Our Partner'});
                        },
                      ),
                      const SizedBox(width: 10),
                      Image.asset('assets/images/logo_komatech.png')
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
