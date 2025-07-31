// {"message":{"profile_avatar":["The profile avatar must not be greater than 2048 kilobytes."]},"code":400}

class ErrorResponse {
  List<Errors> _errors = [];

  List<Errors> get errors => _errors;

  ErrorResponse({List<Errors>? errors}){
    _errors = errors ?? [];
  }

  ErrorResponse.fromJson(dynamic json) {
    if (json["errors"] != null) {
      _errors = [];
      json["errors"].forEach((v) {
        _errors.add(Errors.fromJson(v));
      });
    }
  }
}

class Errors {
  int? _code;
  dynamic _message;

  dynamic get message => _message;

  Errors({int? code, String? message}) {
    _code = code;
    _message = message ?? '';
  }

  Errors.fromJson(dynamic json) {
    //_code = int.tryParse(json["code"].toString());
    _message = json["message"];
  }
}