import 'package:eccmobile/data/models/response/response.dart';

class LoginResponse {
  LoginResponse({
    required this.message,
    required this.accessToken,
    required this.tokenType,
    required this.isAdmin,
    required this.profileResponse,
  });

  late final String message;
  late final String accessToken;
  late final String tokenType;
  late final bool isAdmin;
  late final ProfileResponse profileResponse;

  LoginResponse.fromJson(Map<String, dynamic> json){
    try {
      message = json['message'] ?? "";
      accessToken = json['access_token'] ?? "";
      tokenType = json['token_type'] ?? "";
      isAdmin = json['is_admin'] ?? false;
      profileResponse = ProfileResponse.fromJson(json['data'] as Map<String, dynamic>);
    } catch (e) {
      throw e.toString();
    }
  }
}