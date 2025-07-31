class UpdateMemberBody {
  UpdateMemberBody({
    required this.name,
    required this.email,
    required this.familyRoleId,
    required this.gender,
    required this.birthDate,
    required this.personId,
    this.photo,
  });
  late final String name;
  late final String email;
  late final String familyRoleId;
  late final String birthDate;
  late final String personId;
  late String gender;
  late final String? photo;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['family_role_id'] = familyRoleId;
    _data['birth_date'] = birthDate;
    _data['person_id'] = personId;
    _data['gender'] = gender;
    // _data['photo'] = photo;
    return _data;
  }
}