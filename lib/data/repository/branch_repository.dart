import 'package:dio/dio.dart';
import 'package:eccmobile/data/client/dio/dio_client.dart';
import 'package:eccmobile/data/client/exception/api_error_handler.dart';
import 'package:eccmobile/data/models/body/register_body.dart';
import 'package:eccmobile/data/models/response/api_response.dart';

class BranchRepository {
  final DioClient dioClient;

  BranchRepository({required this.dioClient});

  Future<ApiResponse> getList() async {
    try {
      final Response response = await dioClient.get('branch');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}