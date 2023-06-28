class ItemType {
  final String id;
  final String name;
  final DateTime dateTime;
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
        dateTime: DateTime.tryParse(json["dateTime"]) ?? DateTime.now(),
        order: json["order"],
        nameList: json["nameList"] ?? <String>[],
      );
}
