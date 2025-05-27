import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_b15_firebase/%20models/category.dart';
import 'package:flutter_b15_firebase/%20models/task.dart';
import 'package:flutter_b15_firebase/services/category.dart';
import 'package:flutter_b15_firebase/services/task.dart';
import 'package:flutter_b15_firebase/views/create_task.dart';
import 'package:flutter_b15_firebase/views/get_completed_task.dart';
import 'package:flutter_b15_firebase/views/get_in_completed_task.dart';
import 'package:flutter_b15_firebase/views/get_task_by_category.dart';
import 'package:flutter_b15_firebase/views/profile.dart';
import 'package:flutter_b15_firebase/views/update_task.dart';
import 'package:provider/provider.dart';

class GetAllCategoriesView extends StatelessWidget {
  const GetAllCategoriesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Get All Categories"),
        actions: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfileView()));
          }, icon: Icon(Icons.person))

        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => CreateTaskView()));
        },
        child: Icon(Icons.add),
      ),
      body: StreamProvider.value(
        value: CategoryServices().getAllCategories(),
        initialData: [CategoryModel()],
        builder: (context, child) {
          List<CategoryModel> categoryList =
              context.watch<List<CategoryModel>>();
          return ListView.builder(
              itemCount: categoryList.length,
              itemBuilder: (context, i) {
                return ListTile(
                  leading: Icon(Icons.category),
                  title: Text(categoryList[i].name.toString()),
                  trailing: IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => GetTaskByCategoryID(
                                      model: categoryList[i],
                                    )));
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        size: 17,
                      )),
                );
              });
        },
      ),
    );
  }
}
