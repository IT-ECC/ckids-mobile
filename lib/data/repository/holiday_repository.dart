import 'dart:convert' as convert;
import 'package:eccmobile/data/models/holiday_model.dart';
import 'package:http/http.dart' as http;

class HolidayRepository {
  Future<List<HolidayModel>?> getHoliday() async {
    var url = Uri.parse('https://api-harilibur.vercel.app/api?year=2022');
    final http.Response response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as List<dynamic>;

      return jsonResponse.map((e) {
        return HolidayModel.fromJson(e);
      }).toList();
    }
  }
}