import 'package:dio/dio.dart';
import 'package:eccmobile/data/client/dio/dio_client.dart';
import 'package:eccmobile/data/client/exception/api_error_handler.dart';
import 'package:eccmobile/data/models/family_selected.dart';
import 'package:eccmobile/data/models/response/response.dart';

class PaymentRepository {
  final DioClient dioClient;

  PaymentRepository({required this.dioClient});

  Future<ApiResponse> createPayment({required List<FamilySelected> familySelected, required String eventId, required double grandTotal}) async {
    try {
      Map<String, dynamic> body = {
        "person_id": familySelected.map((e) => e.id).toList(),
        "event_id": eventId,
        "grand_total": grandTotal
      };

      final Response response = await dioClient.post('events/join-upcoming', data: body);

      return ApiResponse.withSuccess(response);
    } on DioError catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}