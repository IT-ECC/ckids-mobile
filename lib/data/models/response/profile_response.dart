class ProfileResponse {
  ProfileResponse({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.email,
    required this.photo,
    required this.birthDate,
    required this.birthDateFormatted,
    required this.registeredDate,
    required this.registeredDateFormatted,
    required this.isNewComers,
    required this.isAdmin,
    this.familyStatus,
  });
  late final String id;
  late final String name;
  late final String address;
  late final String phone;
  late final String email;
  late final String photo;
  late final String birthDate;
  late final String birthDateFormatted;
  late final String registeredDate;
  late final String registeredDateFormatted;
  late final bool isNewComers;
  late final bool isAdmin;
  late final String? familyStatus;

  ProfileResponse.fromJson(Map<String, dynamic> json){
    try {
      id = json['id'];
      name = json['name'];
      address = json['address'];
      phone = json['phone'] ?? "";
      email = json['email'];
      photo = json['photo'];
      birthDate = json['birth_date'];
      birthDateFormatted = json['birth_date_formatted'];
      registeredDate = json['registered_date'];
      registeredDateFormatted = json['registered_date_formatted'];
      isNewComers = json['is_new_comers'];
      isAdmin = json['is_admin'];
      familyStatus = json['family_status'] ?? "";
    } catch (e) {
      print("ProfileResponse.fromJson : " + e.toString());

      throw e.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['address'] = address;
    _data['phone'] = phone;
    _data['email'] = email;
    _data['photo'] = photo;
    _data['birth_date'] = birthDate;
    _data['birth_date_formatted'] = birthDateFormatted;
    _data['registered_date'] = registeredDate;
    _data['registered_date_formatted'] = registeredDateFormatted;
    _data['is_new_comers'] = isNewComers;
    _data['is_admin'] = isAdmin;
    _data['family_status'] = familyStatus;
    return _data;
  }
}