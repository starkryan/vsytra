import 'package:me_lond/models/user.dart';

class Livestream {
  final String id;
  final User host;
  final String title;
  final String? thumbnailUrl;
  final DateTime startTime;
  final int viewerCount;
  final List<String> tags;
  final bool isActive;

  Livestream({
    required this.id,
    required this.host,
    required this.title,
    this.thumbnailUrl,
    required this.startTime,
    this.viewerCount = 0,
    this.tags = const [],
    this.isActive = true,
  });

  factory Livestream.fromJson(Map<String, dynamic> json, {required User host}) {
    return Livestream(
      id: json['id'],
      host: host,
      title: json['title'],
      thumbnailUrl: json['thumbnailUrl'],
      startTime: DateTime.parse(json['startTime']),
      viewerCount: json['viewerCount'] ?? 0,
      tags: List<String>.from(json['tags'] ?? []),
      isActive: json['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hostId': host.id,
      'title': title,
      'thumbnailUrl': thumbnailUrl,
      'startTime': startTime.toIso8601String(),
      'viewerCount': viewerCount,
      'tags': tags,
      'isActive': isActive,
    };
  }
}
