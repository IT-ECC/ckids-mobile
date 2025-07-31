import 'dart:ffi';

import 'package:eccmobile/util/util.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  late SharedPreferences sharedPreferences;

  SharedPref(SharedPreferences shared) {
    sharedPreferences = shared;
  }

  Future<void> setValueLogin({required String token, required String username, required bool isAdmin, required String email, required String photoProfile}) async {
    try {
      await sharedPreferences.setString(AppConstant.TOKEN, token);
      await sharedPreferences.setString(AppConstant.USERNAME, username);
      await sharedPreferences.setBool(AppConstant.IS_ADMIN, isAdmin);
      await sharedPreferences.setString(AppConstant.EMAIL, email);
      await sharedPreferences.setString(AppConstant.PHOTO_PROFILE, photoProfile);
    } catch (e) {
      throw e;
    }
  }

  Future<void> setUsername(String username) async {
    try {
      await sharedPreferences.setString(AppConstant.USERNAME, username);
    } catch (e) {
      throw e;
    }
  }

  Future<String?> getUsername() async {
    try {
      String? token = sharedPreferences.getString(AppConstant.USERNAME);

      return token;
    } catch (e) {
      throw e;
    }
  }

  Future<void> setAdminStatus(bool status) async {
    try {
      await sharedPreferences.setBool(AppConstant.IS_ADMIN, status);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> getAdminStatus() async {
    try {
      bool token = sharedPreferences.getBool(AppConstant.IS_ADMIN) ?? false;

      return token;
    } catch (e) {
      throw e;
    }
  }

  Future<void> setToken(String token) async {
    try {
      await sharedPreferences.setString(AppConstant.TOKEN, token);
    } catch (e) {
      throw e;
    }
  }

  Future<void> setOnBoarding(bool status) async {
    try {
      await sharedPreferences.setBool(AppConstant.IS_ONBOARDING, status);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> getOnBoarding() async {
    try {
      final bool status = sharedPreferences.getBool(AppConstant.IS_ONBOARDING) ?? true;

      return status;
    } catch (e) {
      throw e;
    }
  }

  Future<String?> getToken() async {
    try {
      String? token = sharedPreferences.getString(AppConstant.TOKEN);

      return token;
    } catch (e) {
      return null;
    }
  }

  Future<void> logoutClear() async {
    try {
      sharedPreferences.clear();
      setOnBoarding(false);
    } catch (e) {
      throw e;
    }
  }
}