class FamilyResponse {
  FamilyResponse({
    required this.id,
    required this.branchId,
    required this.name,
    required this.phone,
    required this.address,
    required this.email,
    required this.photo,
    required this.registeredDate,
    required this.registeredDateFormatted,
    required this.birthDate,
    required this.birthDateFormatted,
    required this.isNewComers,
    required this.familyStatus,
    required this.isJoin,
  });
  late final String id;
  late final String branchId;
  late final String name;
  late final String phone;
  late final String address;
  late final String email;
  late final String photo;
  late final String registeredDate;
  late final String registeredDateFormatted;
  late final String birthDate;
  late final String birthDateFormatted;
  late final bool isNewComers;
  late final String familyStatus;
  late final bool isJoin;

  FamilyResponse.fromJson(Map<String, dynamic> json){
    try {
      id = json['id'];
      branchId = json['branch_id'] ?? "";
      name = json['name'];
      phone = json['phone'] ?? "";
      address = json['address'];
      email = json['email'] ?? "";
      photo = json['photo'];
      registeredDate = json['registered_date'];
      isJoin = json['is_join'] ?? false;
      registeredDateFormatted = json['registered_date_formatted'];
      birthDate = json['birth_date'];
      birthDateFormatted = json['birth_date_formatted'];
      isNewComers = json['is_new_comers'];
      familyStatus = json['family_status'] ?? "";
    } catch (e) {
      throw e.toString();
    }
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['branch_id'] = branchId;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['address'] = address;
    _data['email'] = email;
    _data['photo'] = photo;
    _data['registered_date'] = registeredDate;
    _data['registered_date_formatted'] = registeredDateFormatted;
    _data['birth_date'] = birthDate;
    _data['birth_date_formatted'] = birthDateFormatted;
    _data['is_new_comers'] = isNewComers;
    _data['family_status'] = familyStatus;
    return _data;
  }
}