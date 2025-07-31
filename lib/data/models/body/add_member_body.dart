
// TODO : this body same with register
class AddMemberBody {
  AddMemberBody({
    required this.name,
    required this.email,
    required this.familyRoleId,
    required this.gender,
    required this.birthDate,
    required this.username,
    required this.password,
    required this.passwordConfirmation,
    this.photo,
  });
  late final String name;
  late final String email;
  late final String familyRoleId;
  late final String birthDate;
  late final String username;
  late String gender;
  late final String password;
  late final String passwordConfirmation;
  late final String? photo;

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name;
    _data['email'] = email;
    _data['family_role_id'] = familyRoleId;
    _data['birth_date'] = birthDate;
    _data['username'] = username;
    _data['password'] = password;
    _data['password_confirmation'] = passwordConfirmation;
    _data['gender'] = gender;
    // _data['photo'] = photo;
    return _data;
  }
}