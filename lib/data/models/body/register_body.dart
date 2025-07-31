class RegisterBody {
  RegisterBody({
    this.branchId,
    required this.name,
    this.phone,
    required this.email,
    this.address,
    this.birthDate,
    required this.familyName,
    required this.familyRoleId,
    required this.gender,
    this.isNewComers,
    required this.password,
    required this.passwordConfirmation,
    this.photo,
  });

  late String? branchId;
  late String name;
  late String? phone;
  late String email;
  late String? address;
  late String? birthDate;
  late String familyName;
  late String familyRoleId;
  late String gender;
  late bool? isNewComers;
  late String password;
  late String passwordConfirmation;
  late String? photo;

  RegisterBody.fromJson(Map<String, dynamic> json){
    branchId = json['branch_id'];
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    address = json['address'];
    birthDate = json['birth_date'];
    familyName = json['family_name'];
    familyRoleId = json['family_role_id'];
    gender = json['gender'];
    isNewComers = json['is_new_comers'];
    password = json['password'];
    passwordConfirmation = json['password_confirmation'];
    photo = json['photo'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['branch_id'] = branchId ?? "";
    _data['name'] = name;
    _data['phone'] = phone ?? "";
    _data['email'] = email;
    _data['address'] = address ?? "-";
    _data['birth_date'] = birthDate ?? "";
    _data['family_name'] = familyName;
    _data['gender'] = gender;
    _data['family_role_id'] = familyRoleId;
    _data['is_new_comers'] = isNewComers ?? true;
    _data['password'] = password;
    _data['password_confirmation'] = passwordConfirmation;

    // TODO : Implement this feature
    _data['is_new_comers'] = true;
    // _data['photo'] = photo;
    return _data;
  }
}