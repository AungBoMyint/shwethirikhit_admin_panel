class VlogVideo {
  final String id;
  final String title;
  final String image;
  final String videoURL;
  final int minutes;
  final DateTime dateTime;
  final int? order;
  final List? nameList;
  const VlogVideo({
    required this.id,
    required this.title,
    required this.image,
    required this.videoURL,
    required this.minutes,
    required this.dateTime,
    required this.order,
    required this.nameList,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'videoURL': videoURL,
        'minutes': minutes,
        'dateTime': dateTime.toIso8601String(),
        'order': order,
        'nameList': nameList,
      };

  factory VlogVideo.fromJson(Map<String, dynamic> json) => VlogVideo(
        id: json["id"],
        title: json["title"],
        image: json["image"],
        videoURL: json["videoURL"],
        minutes: json["minutes"],
        dateTime: DateTime.tryParse(json["dateTime"]) ?? DateTime.now(),
        order: json["order"] as int?,
        nameList: json["nameList"] ?? <String>[],
      );
}
