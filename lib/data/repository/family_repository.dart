import 'package:dio/dio.dart';
import 'package:eccmobile/data/client/dio/dio_client.dart';
import 'package:eccmobile/data/client/exception/api_error_handler.dart';
import 'package:eccmobile/data/models/body/add_member_body.dart';
import 'package:eccmobile/data/models/body/update_member_body.dart';
import 'package:eccmobile/data/models/response/response.dart';

class FamilyRepository {
  final DioClient dioClient;

  FamilyRepository({required this.dioClient});

  Future<ApiResponse> getList({String? eventId}) async {
    try {
      final Response response = await dioClient.get('families/get-members', queryParameters: {
        'event_id': eventId
      });

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> addMember({required AddMemberBody addMemberBody}) async {
    try {
      var formData = FormData.fromMap(addMemberBody.toJson());

      if (addMemberBody.photo != null) {
        String fileName = addMemberBody.photo!.split('/').last;
        formData.files.add(MapEntry('photo',
          MultipartFile.fromFileSync(addMemberBody.photo!),
        ));
      }

      final Response response = await dioClient.post('families/add-members', data: formData);

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> updateMember({required UpdateMemberBody updateMemberBody}) async {
    try {
      var formData = FormData.fromMap(updateMemberBody.toJson());

      if (updateMemberBody.photo != null) {
        String fileName = updateMemberBody.photo!.split('/').last;
        formData.files.add(MapEntry('photo',
          MultipartFile.fromFileSync(updateMemberBody.photo!),
        ));
      }

      final Response response = await dioClient.post('families/edit-members', data: formData);

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getListRole() async {
    try {
      final Response response = await dioClient.get('family-role/list');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}