import 'package:get/get.dart';

class ParticipantResponse {
  ParticipantResponse({
    required this.personId,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.photo,
    required this.birthDate,
    required this.birthDateFormatted,
    required this.eventId,
    required this.status,
    required this.checkinTime,
    required this.checkinTimeFormatted,
    required this.checkoutTime,
    required this.checkoutTimeFormatted,
    required this.bookingDate,
    required this.bookerPersonId,
  });
  late final String personId;
  late final String name;
  late final String address;
  late final String phone;
  late final String email;
  late final String photo;
  late final String birthDate;
  late final String birthDateFormatted;
  late final String eventId;
  late final String status;
  late final String checkinTime;
  late final String checkinTimeFormatted;
  late final String checkoutTime;
  late final String checkoutTimeFormatted;
  late final String bookingDate;
  late final String bookerPersonId;

  ParticipantResponse.fromJson(Map<String, dynamic> json){
    try {
      personId = json['person_id'];
      name = json['name'];
      address = json['address'] ?? "";
      phone = json['phone'] ?? "";
      email = json['email'] ?? "";
      photo = json['photo'];
      birthDate = json['birth_date'] ?? "";
      birthDateFormatted = json['birth_date_formatted'] ?? "";
      eventId = json['event_id'];
      status = json['status'];
      checkinTime = json['checkin_time'] ?? "";
      checkinTimeFormatted = json['checkin_time_formatted'] ?? "";
      checkoutTime = json['checkout_time'] ?? "";
      checkoutTimeFormatted = json['checkout_time_formatted'] ?? "";
      bookingDate = json['booking_date'] ?? "";
      bookerPersonId = json['booker_person_id'] ?? "";
    } catch (e) {
      throw e.toString();
    }
  }
}