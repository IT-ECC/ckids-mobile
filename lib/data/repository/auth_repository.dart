import 'package:dio/dio.dart';
import 'package:eccmobile/data/client/dio/dio_client.dart';
import 'package:eccmobile/data/client/exception/api_error_handler.dart';
import 'package:eccmobile/data/models/body/register_body.dart';
import 'package:eccmobile/data/models/response/api_response.dart';

class AuthRepository {
  final DioClient dioClient;

  AuthRepository({required this.dioClient});

  Future<ApiResponse> login({required String username, required String password}) async {
    try {
      final Response response = await dioClient.post('login', data: {
        'email': username,
        'password': password
      });

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> register({required RegisterBody registerBody}) async {
    try {
      var formData = FormData.fromMap(registerBody.toJson());

      if (registerBody.photo != null) {
        String fileName = registerBody.photo!.split('/').last;
        formData.files.add(MapEntry('photo',
          MultipartFile.fromFileSync(registerBody.photo!),
        ));
      }

      final Response response = await dioClient.post('register', data: formData);

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> logout() async {
    try {
      final Response response = await dioClient.post('logout');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getProfile() async {
    try {
      final Response response = await dioClient.get('get-profile');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}