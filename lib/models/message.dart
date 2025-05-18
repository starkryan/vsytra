import 'package:me_lond/models/user.dart';
import 'package:me_lond/models/gift.dart';

enum MessageType { text, gift, system }

class Message {
  final String id;
  final User sender;
  final DateTime timestamp;
  final MessageType type;
  final String? text;
  final Gift? gift;

  Message({
    required this.id,
    required this.sender,
    required this.timestamp,
    required this.type,
    this.text,
    this.gift,
  }) : assert(
         (type == MessageType.text && text != null) ||
             (type == MessageType.gift && gift != null) ||
             (type == MessageType.system && text != null),
         'Message must have appropriate content for its type',
       );

  factory Message.text({
    required String id,
    required User sender,
    required String text,
    DateTime? timestamp,
  }) {
    return Message(
      id: id,
      sender: sender,
      timestamp: timestamp ?? DateTime.now(),
      type: MessageType.text,
      text: text,
    );
  }

  factory Message.gift({
    required String id,
    required User sender,
    required Gift gift,
    DateTime? timestamp,
  }) {
    return Message(
      id: id,
      sender: sender,
      timestamp: timestamp ?? DateTime.now(),
      type: MessageType.gift,
      gift: gift,
    );
  }

  factory Message.system({
    required String id,
    required User sender,
    required String text,
    DateTime? timestamp,
  }) {
    return Message(
      id: id,
      sender: sender,
      timestamp: timestamp ?? DateTime.now(),
      type: MessageType.system,
      text: text,
    );
  }

  factory Message.fromJson(
    Map<String, dynamic> json, {
    required User sender,
    Gift? gift,
  }) {
    final type = MessageType.values.byName(json['type']);

    return Message(
      id: json['id'],
      sender: sender,
      timestamp: DateTime.parse(json['timestamp']),
      type: type,
      text: json['text'],
      gift: gift,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': sender.id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'text': text,
      'giftId': gift?.id,
    };
  }
}
