import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoProvider with ChangeNotifier {
  void refresh() {
    getCompletedTaskCount();
    notifyListeners();
  }

  List<String> allTasks = [];
  TextEditingController newTaskController = TextEditingController();
  bool showCompletedStatus = false;
  int completedTaskCount = 0;
  readAllTasks() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    allTasks = pref.getStringList("tasks") ?? [];
    refresh();
  }

  toggleTask(int index) async {
    Map selectedTask = jsonDecode(allTasks[index]);
    Map modifiedTask = {"created_on": selectedTask["created_on"], "title": selectedTask["title"], "status": !(selectedTask["status"])};
    final SharedPreferences pref = await SharedPreferences.getInstance();
    allTasks = pref.getStringList("tasks") ?? [];
    allTasks[index] = jsonEncode(modifiedTask);
    pref.setStringList("tasks", allTasks);
    refresh();
  }

  deleteTask(int index) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    allTasks = pref.getStringList("tasks") ?? [];
    allTasks.removeAt(index);
    pref.setStringList("tasks", allTasks);
    refresh();
  }

  createNewTask() async {
    if (newTaskController.text.isNotEmpty) {
      Map newTask = {"created_on": DateTime.now().millisecondsSinceEpoch, "title": newTaskController.text, "status": false};
      final SharedPreferences pref = await SharedPreferences.getInstance();
      allTasks = pref.getStringList("tasks") ?? [];
      allTasks.add(jsonEncode(newTask));
      pref.setStringList("tasks", allTasks);
      newTaskController.clear();
      refresh();
    }
  }

  toggleShowCompleted() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    checkShowCompletedStatus();
    showCompletedStatus = !showCompletedStatus;
    pref.setBool("showCompleted", showCompletedStatus);
    refresh();
  }

  checkShowCompletedStatus() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    showCompletedStatus = pref.getBool("showCompleted") ?? false;
    refresh();
  }

  getCompletedTaskCount() {
    completedTaskCount = 0;
    for (int i = 0; i < allTasks.length; i++) {
      Map selected = jsonDecode(allTasks[i]);
      selected["status"] == true ? completedTaskCount++ : null;
    }
  }
}
