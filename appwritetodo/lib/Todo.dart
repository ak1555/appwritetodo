import 'package:appwrite/models.dart';

class Task{
  final String id;
  final String taskk;
  final bool isComplete;

  Task({
    required this.id,
    required this.taskk,
    required this.isComplete
  });
factory Task.formDocument(Document doc){
  print(doc);
  return Task(id: doc.$id, taskk: doc.data['taskk'], isComplete: doc.data["isComplete"]);
}
}