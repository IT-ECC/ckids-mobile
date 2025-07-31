import 'package:dio/dio.dart';
import 'package:eccmobile/data/models/response/response.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioError) {
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioErrorType.connectTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioErrorType.other:
              errorDescription =
              "Connection to API server failed due to internet connection";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription =
              "Receive timeout in connection with API server";
              break;
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 404:
                case 500:
                  errorDescription = error.response!.statusMessage;
                  break;
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  errorDescription = "Failed to load data - status code: ${error.response!.statusCode}";

                  print("error.response");
                  print(error.response);

                  if (error.response != null) {
                    Errors errorResponse = Errors.fromJson(error.response!.data);
                    if (errorResponse != null) {
                      errorDescription = errorResponse.message;
                    } else {
                      errorDescription = "Failed to load data - status code: ${error.response!.statusCode}";
                    }
                  } else {
                    errorDescription = "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      errorDescription = "is not a subtype of exception";
    }
    return errorDescription;
  }
}
