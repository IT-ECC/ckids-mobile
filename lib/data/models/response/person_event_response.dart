// TODO : Change to participant response

class PersonEventResponse {
  PersonEventResponse({
    required this.personId,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.photo,
    required this.birthDate,
    required this.eventId,
    this.checkinTime,
    this.checkoutTime,
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
  late final String eventId;
  late final String? checkinTime;
  late final String? checkoutTime;
  late final String bookingDate;
  late final String bookerPersonId;

  PersonEventResponse.fromJson(Map<String, dynamic> json){
    personId = json['person_id'];
    name = json['name'];
    address = json['address'];
    phone = json['phone'];
    email = json['email'];
    photo = json['photo'];
    birthDate = json['birth_date'];
    eventId = json['event_id'];
    checkinTime = json['checkin_time'];
    checkoutTime = json['checkout_time'];
    bookingDate = json['booking_date'];
    bookerPersonId = json['booker_person_id'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['person_id'] = personId;
    _data['name'] = name;
    _data['address'] = address;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['photo'] = photo;
    _data['birth_date'] = birthDate;
    _data['event_id'] = eventId;
    _data['checkin_time'] = checkinTime;
    _data['checkout_time'] = checkoutTime;
    _data['booking_date'] = bookingDate;
    _data['booker_person_id'] = bookerPersonId;
    return _data;
  }
}