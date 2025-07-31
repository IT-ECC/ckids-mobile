import 'dart:async';

import 'package:eccmobile/bloc/auth_bloc/auth_bloc.dart';
import 'package:eccmobile/bloc/config/config_cubit.dart';
import 'package:eccmobile/component/bottom_navigation.dart';
import 'package:eccmobile/data/models/response/config_response.dart';
import 'package:eccmobile/data/repository/config_repository.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:eccmobile/screens/example/holiday_screen.dart';
import 'package:eccmobile/screens/home/home_screen.dart';
import 'package:eccmobile/screens/screens.dart';
import 'package:eccmobile/size_config.dart';
import 'package:eccmobile/util/resource/version_helper.dart';
import 'package:eccmobile/util/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:launch_review/launch_review.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:percent_indicator/percent_indicator.dart';

import 'component/app_colors.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final sl = GetIt.instance;
  late SharedPref sharedPref;
  late final AuthBloc authBloc;
  late final ConfigCubit configCubit;
  late final ConfigRepository configRepository;
  late final VersionResponse? versionResponse;
  late String versionApp;
  late String packageName;
  late bool redirectToOnboarding, isUserLogin, roleAdmin, isLoading;

  @override
  void initState() {
    sharedPref = sl();
    authBloc = sl();
    configCubit = sl();
    configRepository = sl();
    configCubit.getVersion();
    authBloc.add(AuthEventGetProfile());

    configRepository.getConfig().listen((event) {
      setState(() {
        versionResponse = event;
      });
    });

    PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      setState(() {
        versionApp = packageInfo.version;
        packageName = packageInfo.packageName;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthBloc, AuthState>(
          bloc: authBloc,
          listener: (context, AuthState authState) async {
            final bool onBoarding = await sharedPref.getOnBoarding();
            final bool isAdmin = await sharedPref.getAdminStatus();

            setState(() {
              redirectToOnboarding = onBoarding;
              isUserLogin = (authState is AuthStateProfile) ? true : false;
              roleAdmin = isAdmin;
            });

            if (versionResponse != null) {
              if (checkAppVersion(versionApp, versionResponse!.versionCode)) {
                _showVersionDialog(context, appVersion: versionApp, enforceVersion: versionResponse!.versionCode);
              } else {
                if (redirectToOnboarding) {
                  Navigator.pushNamedAndRemoveUntil(context, onBoardingScreen, (route) => false);
                }

                if (isUserLogin) {
                  Navigator.pushNamedAndRemoveUntil(context, mainScreen, (route) => false, arguments: {'isAdmin': roleAdmin});
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
                }
              }
            } else {
              Navigator.pushNamedAndRemoveUntil(context, loginScreen, (route) => false);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.whiteSmoke,
        body: Container(
          padding: const EdgeInsets.only(top: 14, right: 35, left: 35),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 300,
                height: 300,
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.cadmiumOrange),
                    borderRadius:
                    const BorderRadius.all(Radius.circular(40))),
                child: LinearPercentIndicator(
                  padding: const EdgeInsets.all(0),
                  barRadius: const Radius.circular(40),
                  animation: true,
                  lineHeight: 11.0,
                  animationDuration: 1500,
                  percent: 1,
                  progressColor: AppColors.cadmiumOrange,
                  backgroundColor: AppColors.whiteSmoke,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }

  _showVersionDialog(context, {required String appVersion, required String enforceVersion}) async {
    await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String title = "Update App?";
        String message = "A new version of Creative Kids is available! ${enforceVersion} is now available-you have ${appVersion}";
        String btnUpdate = "Update Now";

        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(onPressed: () => LaunchReview.launch(
              androidAppId: packageName,
              // TODO : Make sure for IOS
              iOSAppId: "585027354",
            ), child: Text(btnUpdate))
          ],
        );
      },
    );
  }
}
