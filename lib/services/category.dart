import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_b15_firebase/%20models/category.dart';

class CategoryServices {
  ///Get All Categories
  Stream<List<CategoryModel>> getAllCategories() {
    return FirebaseFirestore.instance
        .collection('taskCategoryCollection')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((taskList) => taskList.docs
            .map((taskModel) => CategoryModel.fromJson(taskModel.data()))
            .toList());
  }
}
