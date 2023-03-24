import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  String message;
  bool? isMe;
  Timestamp sendTime;

  Message({
    required this.message,
    this.isMe,
    required this.sendTime,
  });
}
