class FamilySelected {
  late final String id;
  late final String name;
  late final bool selected;
  late final bool isJoin;

  FamilySelected({
    required this.id,
    required this.name,
    required this.selected,
    required this.isJoin
  });

  FamilySelected copyWith({
    String? id,
    String? name,
    bool? selected,
    bool? isJoin
  }) {
    return FamilySelected(
      id: id ?? this.id,
      name: name ?? this.name,
      selected: selected ?? this.selected,
      isJoin: isJoin ?? this.isJoin
    );
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['selected'] = selected;
    _data['isJoin'] = isJoin;
    return _data;
  }
}