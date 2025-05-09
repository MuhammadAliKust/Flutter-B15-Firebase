import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_b15_firebase/%20models/task.dart';

class TaskServices {
  ///Create Task
  Future createTask(TaskModel model) async {
    DocumentReference docRef =
        FirebaseFirestore.instance.collection('taskCollection').doc();
    return await FirebaseFirestore.instance
        .collection('taskCollection')
        .doc(docRef.id)
        .set(model.toJson(docRef.id));
  }

  ///Delete Task
  Future deleteTask(String taskID) async {
    return await FirebaseFirestore.instance
        .collection('taskCollection')
        .doc(taskID)
        .delete();
  }

  ///Update Task
  Future updateTask(TaskModel model) async {
    return await FirebaseFirestore.instance
        .collection('taskCollection')
        .doc(model.docId.toString())
        .update({'title': model.title, 'description': model.description});
  }

  ///Mark Task as Complete
  Future markTaskAsComplete(String taskID) async {
    return await FirebaseFirestore.instance
        .collection('taskCollection')
        .doc(taskID)
        .update({'isCompleted': true});
  }

  ///Get All Tasks
  Stream<List<TaskModel>> getAllTasks() {
    return FirebaseFirestore.instance
        .collection('taskCollection')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((taskList) => taskList.docs
            .map((taskModel) => TaskModel.fromJson(taskModel.data()))
            .toList());
  }

  ///Get Completed Tasks
  Stream<List<TaskModel>> getCompletedTasks() {
    return FirebaseFirestore.instance
        .collection('taskCollection')
        .where('isCompleted', isEqualTo: true)
        .snapshots()
        .map((taskList) => taskList.docs
            .map((taskModel) => TaskModel.fromJson(taskModel.data()))
            .toList());
  }

  ///Get InCompleted Tasks
  Stream<List<TaskModel>> getInCompletedTasks() {
    return FirebaseFirestore.instance
        .collection('taskCollection')
        .where('isCompleted', isEqualTo: false)
        .snapshots()
        .map((taskList) => taskList.docs
            .map((taskModel) => TaskModel.fromJson(taskModel.data()))
            .toList());
  }
}
