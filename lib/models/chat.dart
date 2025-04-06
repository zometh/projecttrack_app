
import 'package:cloud_firestore/cloud_firestore.dart';

class Chat{
  final String id;
  final String sender;
  final String message;
  final String taskId;
  final Timestamp date;
  Chat({
    required this.id,
    required this.sender,
    required this.message,
    required this.taskId,
    required this.date,
  });
  factory Chat.fromFirestore(Map<String, dynamic> data) {
    return Chat(
      id: data['id'],
      sender: data['sender'],
      message: data['message'],
      taskId: data['taskId'],
        date: data['date'],
    );
  }

}