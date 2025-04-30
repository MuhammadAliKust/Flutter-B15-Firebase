import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/task.dart';
import 'package:flutter_b15_firebase/services/task.dart';

class CreateTaskView extends StatefulWidget {
  CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Task"),
      ),
      body: Column(
        children: [
          TextField(
            controller: titleController,
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: descriptionController,
          ),
          SizedBox(
            height: 20,
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : ElevatedButton(
                  onPressed: () async {
                    try {
                      isLoading = true;
                      setState(() {});
                      await TaskServices()
                          .createTask(TaskModel(
                              title: titleController.text,
                              description: descriptionController.text,
                              isCompleted: false,
                              createdAt: DateTime.now().millisecondsSinceEpoch))
                          .then((val) {
                        isLoading = false;
                        setState(() {});
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text("Message"),
                                content:
                                    Text("Task has been created successfully"),
                                actions: [
                                  TextButton(
                                      onPressed: () {}, child: Text("Okay"))
                                ],
                              );
                            });
                      });
                    } catch (error) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(error.toString())));
                    }
                  },
                  child: Text("Create Task"))
        ],
      ),
    );
  }
}
