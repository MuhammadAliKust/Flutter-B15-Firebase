import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/category.dart';
import 'package:flutter_b15_firebase/%20models/task.dart';
import 'package:flutter_b15_firebase/providers/user.dart';
import 'package:flutter_b15_firebase/services/task.dart';
import 'package:flutter_b15_firebase/views/create_task.dart';
import 'package:flutter_b15_firebase/views/get_completed_task.dart';
import 'package:flutter_b15_firebase/views/get_in_completed_task.dart';
import 'package:flutter_b15_firebase/views/update_task.dart';
import 'package:provider/provider.dart';

class GetTaskByCategoryID extends StatelessWidget {
  final CategoryModel model;

  const GetTaskByCategoryID({super.key, required this.model});

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Get Category Task"),
      ),
      body: StreamProvider.value(
        value: TaskServices().getTaskBtCategoryID(model.docId.toString(),user.getUser()!.docId.toString()),
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
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                          value: taskList[i].isCompleted,
                          onChanged: (val) async {
                            try {
                              await TaskServices()
                                  .markTaskAsComplete(
                                      taskList[i].docId.toString())
                                  .then((val) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Task has been completed successfully')));
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          }),
                      IconButton(
                          onPressed: () async {
                            try {
                              await TaskServices()
                                  .deleteTask(taskList[i].docId.toString())
                                  .then((val) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        'Task has been deleted successfully')));
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(e.toString())));
                            }
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          )),
                      IconButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => UpdateTaskView(
                                          model: taskList[i],
                                        )));
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          )),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
