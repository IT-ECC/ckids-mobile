import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class VersionResponse {
  late String versionCode;
  late Timestamp versionDate;

  VersionResponse({
    required this.versionCode,
    required this.versionDate,
  });

  VersionResponse.fromJson(Map<String, dynamic> json) {
    if (Platform.isAndroid) {
      versionCode = json['versionCodeAndroid'];
      versionDate = json['versionDateAndroid'];
    } else if (Platform.isIOS) {
      versionCode = json['versionCodeIOS'];
      versionDate = json['versionDateIOS'];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['versionCode'] = versionCode;
    data['versionDate'] = versionDate;
    return data;
  }
}
