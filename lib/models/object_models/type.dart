class ItemType {
  final String id;
  final String name;
  final String dateTime;
  final int order;
  final List? nameList;
  const ItemType({
    required this.id,
    required this.name,
    required this.dateTime,
    required this.order,
    required this.nameList,
  });
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'dateTime': dateTime,
        'order': order,
        'nameList': nameList,
      };
  factory ItemType.fromJson(Map<String, dynamic> json) => ItemType(
        id: json["id"],
        name: json["name"],
        dateTime: json["dateTime"],
        order: json["order"],
        nameList: json["nameList"] ?? <String>[],
      );
}
