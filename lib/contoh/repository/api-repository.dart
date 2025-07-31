import 'package:eccmobile/contoh/models/covid-list.dart';
import 'package:eccmobile/contoh/repository/api-provider.dart';

class ApiRepository {
  final _provider = ApiProvider();

  Future<CovidModel> fetchCovidList() {
    return _provider.fetchCovidList();
  }
}

class NetworkError extends Error {}
