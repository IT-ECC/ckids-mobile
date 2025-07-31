import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'dart:core';
import 'package:eccmobile/data/models/joke_model.dart';

class JokeRepository {
  final String _baseUrl = "https://v2.jokeapi.dev/joke/Any";

  Future<JokeModel> getJoke() async {
    final response = await http.get(Uri.parse(_baseUrl));
    if (response.statusCode == 200) {
      return jokeModelFromJson(response.body);
    } else {
      throw Exception('Failed to load Joke');
    }
  }
}
