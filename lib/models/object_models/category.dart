class Category {
  final String id;
  final String name;
  final String image;
  final int? order;
  final DateTime dateTime;
  final List? nameList;
  const Category({
    required this.id,
    required this.name,
    required this.image,
    this.order,
    required this.dateTime,
    required this.nameList,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "image": image,
        "name": name,
        'order': order,
        'dateTime': dateTime.toIso8601String(),
        'nameList': nameList ?? <String>[],
      };

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json["id"] as String,
        name: json["name"] as String,
        image: json["image"] as String,
        order: json["order"] as int?,
        nameList: json["nameList"] ?? <String>[],
        dateTime:
            DateTime.tryParse(json["dateTime"] ?? "11/2023") ?? DateTime.now(),
      );
}
