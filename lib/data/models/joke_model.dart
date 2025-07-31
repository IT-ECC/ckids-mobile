import 'dart:convert';

JokeModel jokeModelFromJson(String str) => JokeModel.fromJson(json.decode(str));

String jokeModelToJson(JokeModel data) => json.encode(data.toJson());

class JokeModel {
  JokeModel({
    required this.setup,
    required this.delivery,
    required this.id,
  });

  late final String setup;
  late final String delivery;
  late final int id;

  factory JokeModel.fromJson(Map<String, dynamic> json) => JokeModel(
        setup: json["setup"] ?? json["joke"],
        delivery: json["delivery"] ?? "",
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "setup": setup,
        "delivery": delivery,
        "id": id,
      };
}
