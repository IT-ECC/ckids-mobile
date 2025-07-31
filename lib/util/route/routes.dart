import 'dart:ui';

import 'package:eccmobile/data/models/response/response.dart';
import 'package:eccmobile/data/shared_pref.dart';
import 'package:eccmobile/onboarding_screen.dart';
import 'package:eccmobile/screens/event/add_event_screen.dart';
import 'package:eccmobile/screens/event/detail_admin_event_screen.dart';
import 'package:eccmobile/screens/event/detail_event_screen.dart';
import 'package:eccmobile/screens/home/family_profile_screen.dart';
import 'package:eccmobile/screens/main_screen.dart';
import 'package:eccmobile/screens/member/add_member_screen.dart';
import 'package:eccmobile/screens/member/update_member_screen.dart';
import 'package:eccmobile/screens/payment_screen.dart';
import 'package:eccmobile/screens/webview_screen.dart';
import 'package:flutter/material.dart';
import 'package:eccmobile/util/util.dart';
import 'package:eccmobile/screens/screens.dart';
import 'package:get_it/get_it.dart';

class Routes {
  Route<dynamic> onGenerateRoute(RouteSettings settings) {
    Map<String, dynamic> args = (settings.arguments ?? <String, dynamic>{}) as Map<String, dynamic>;

    switch (settings.name) {
      case splashScreen:
        return MaterialPageRoute(builder: (context) {
          return SplashScreen();
        });

      case addEventScreen:
        return MaterialPageRoute(builder: (context) {
          return AddEventScreen();
        });

      case mainScreen:
        return MaterialPageRoute(builder: (context) {
          bool isAdmin = args['isAdmin'] ?? false;
          int currentIndex = args['currentIndex'] ?? 0;

          return MainScreen(currentIndex: currentIndex, isAdmin: isAdmin);
        });

      case onBoardingScreen:
        return MaterialPageRoute(builder: (context) {
          return OnboardingScreen();
        });

      case loginScreen:
        return MaterialPageRoute(builder: (context) {
          return LoginScreen();
        });
        
      case familyProfileScreen:
        return MaterialPageRoute(builder: (context) {
          return FamilyPersonScreen(familyResponse: args['familyResponse'] as FamilyResponse);
        });

      case detailEventScreen:
        return MaterialPageRoute(builder: (context) {
          return DetailEventScreen(eventResponse: args['eventResponse'] as EventResponse);
        });

      case detailAdminEventScreen:
        return MaterialPageRoute(builder: (context) {
          return DetailAdminEventScreen(eventResponse: args['eventResponse'] as EventResponse);
        });

      case addMemberScreen:
        return MaterialPageRoute(builder: (context) {
          return AddMemberScreen();
        });

      case updateMemberScreen:
        return MaterialPageRoute(builder: (context) {
          return UpdateMemberScreen(
            familyResponse: args['familyResponse'] as FamilyResponse,
          );
        });

      case paymentScreen:
        return MaterialPageRoute(builder: (context) {
          return PaymentScreen(
            snapToken: args['snapToken'],
            url: args['url'],
            calculateAmount: args['calculateAmount'],
            familyParticipant: args['familyParticipant'],
          );
        });

      case webViewScreen:
        return MaterialPageRoute(builder: (context) {
          return WebViewScreen(
            url: args['url'],
            title: args['title']
          );
        });

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
                child: Text('No route defined for ${settings.name}')),
          )
        );
    }
  }
}