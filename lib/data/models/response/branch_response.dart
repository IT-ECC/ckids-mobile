class BranchResponse {
  BranchResponse({
    required this.id,
    required this.name,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });
  late final String id;
  late final String name;
  late final bool isDefault;
  late final String createdAt;
  late final String updatedAt;

  BranchResponse.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    isDefault = json['is_default'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['is_default'] = isDefault;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}