import 'package:dio/dio.dart';
import 'package:eccmobile/data/client/dio/dio_client.dart';
import 'package:eccmobile/data/client/exception/api_error_handler.dart';
import 'package:eccmobile/data/models/body/add_event_body.dart';
import 'package:eccmobile/data/models/response/response.dart';

class EventRepository {
  final DioClient dioClient;

  EventRepository({required this.dioClient});

  Future<ApiResponse> getListEvent() async {
    try {
      final Response response = await dioClient.get('events');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getUpcomingEvent() async {
    try {
      final Response response = await dioClient.get('events/get-upcoming');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getBookedEvent() async {
    try {
      final Response response = await dioClient.get('events/get-booked');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> getListPerson({required String eventId}) async {
    try {
      final Response response = await dioClient.get('events/list-person?event_id=${eventId}');

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> scanQUser({required String eventId, required String personId}) async {
    try {
      final Response response = await dioClient.post('events/check', data: {
        'person_id': personId,
        'event_id': eventId
      });

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> create({required AddEventBody addEventBody}) async {
    try {
      var formData = FormData.fromMap(addEventBody.toJson());

      if (addEventBody.photo != null) {
        String fileName = addEventBody.photo!.split('/').last;
        formData.files.add(MapEntry('photo',
          MultipartFile.fromFileSync(addEventBody.photo!),
        ));
      }

      final Response response = await dioClient.post('events/create', data: formData);

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}