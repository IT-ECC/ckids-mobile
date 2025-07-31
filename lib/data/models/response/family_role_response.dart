class FamilyRoleResponse {
  FamilyRoleResponse({
    required this.id,
    required this.name,
    required this.isPaid,
  });
  late final String id;
  late final String name;
  late final bool isPaid;

  FamilyRoleResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    isPaid = json['is_paid'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['is_paid'] = isPaid;
    return _data;
  }
}