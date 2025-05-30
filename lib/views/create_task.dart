import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/category.dart';
import 'package:flutter_b15_firebase/%20models/task.dart';
import 'package:flutter_b15_firebase/providers/user.dart';
import 'package:flutter_b15_firebase/services/category.dart';
import 'package:flutter_b15_firebase/services/task.dart';
import 'package:provider/provider.dart';

class CreateTaskView extends StatefulWidget {
  CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isLoading = false;

  List<CategoryModel> categoryList = [];

  CategoryModel? _selectedCategory;

  getAllCategories() {
    CategoryServices().getAllCategories().first.then((val) {
      categoryList = val;
      setState(() {});
    });
  }

  @override
  void initState() {
    getAllCategories();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
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
          DropdownButton(
              items: categoryList
                  .map((e) => DropdownMenuItem(
                        child: Text(e.name.toString()),
                        value: e,
                      ))
                  .toList(),
              value: _selectedCategory,
              isExpanded: true,
              hint: Text("Select Category"),
              onChanged: (val) {
                _selectedCategory = val;
                setState(() {});
              }),
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
                              userID: userProvider.getUser()!.docId.toString(),
                              categoryID: _selectedCategory!.docId.toString(),
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
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      },
                                      child: Text("Okay"))
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
