import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/task.dart';
import 'package:flutter_b15_firebase/services/task.dart';
import 'package:flutter_b15_firebase/views/create_task.dart';
import 'package:provider/provider.dart';

class GetInCompletedTaskView extends StatelessWidget {
  const GetInCompletedTaskView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get InCompleted Task"),
      ),
      body: StreamProvider.value(
        value: TaskServices().getInCompletedTasks(),
        initialData: [TaskModel()],
        builder: (context, child) {
          List<TaskModel> taskList = context.watch<List<TaskModel>>();
          return ListView.builder(
              itemCount: taskList.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Icon(Icons.task),
                  title: Text(taskList[i].title.toString()),
                  subtitle: Text(taskList[i].description.toString()),
                  trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                      )),
                );
              });
        },
      ),
    );
  }
}
