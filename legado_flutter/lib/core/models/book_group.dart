class BookGroup {
  int groupId;
  String groupName;
  int order;

  BookGroup({this.groupId = 0, this.groupName = "", this.order = 0});

  factory BookGroup.fromMap(Map<String, dynamic> map) => BookGroup(
    groupId: map['groupId'] as int? ?? 0,
    groupName: map['groupName'] as String? ?? '',
    order: map['order'] as int? ?? 0,
  );

  Map<String, dynamic> toMap() => {'groupId': groupId, 'groupName': groupName, 'order': order};
}
