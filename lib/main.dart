import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ToDoProvider())],
      child: MaterialApp(themeMode: ThemeMode.dark, debugShowCheckedModeBanner: false, title: 'ToDos', theme: ThemeData(useMaterial3: true), home: const TodoPage()));
}

class TodoPage extends StatelessWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Provider.of<ToDoProvider>(context, listen: false).readAllTasks();
    return Scaffold(
        floatingActionButton: Consumer<ToDoProvider>(builder: (context, toDoProvider, child) => FloatingActionButton(child: const Icon(Icons.refresh), onPressed: () => toDoProvider.readAllTasks())),
        appBar: AppBar(title: const Text("ToDo"), actions: [
          const Text("Show Completed  "),
          Consumer<ToDoProvider>(builder: (context, toDoProvider, child) => Switch(value: toDoProvider.showCompletedStatus, onChanged: (value) => toDoProvider.toggleShowCompleted()))
        ]),
        body: Column(children: [
          Padding(
              padding: const EdgeInsets.all(24),
              child: Consumer<ToDoProvider>(
                  builder: (context, toDoProvider, child) => TextField(
                      autofocus: true,
                      controller: toDoProvider.newTaskController,
                      onSubmitted: (value) => toDoProvider.createNewTask(),
                      decoration: InputDecoration(hintText: "Add New Task", suffixIcon: IconButton(onPressed: () => toDoProvider.createNewTask(), icon: Icon(Icons.adaptive.arrow_forward), iconSize: 18))))),
          Consumer<ToDoProvider>(
            builder: (context, toDoProvider, child) => toDoProvider.allTasks.isEmpty
                ? const SizedBox()
                : Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24).copyWith(bottom: 6),
                    child: Stack(alignment: Alignment.center, children: [
                      LinearProgressIndicator(value: toDoProvider.completedTaskCount / toDoProvider.allTasks.length, minHeight: 24, borderRadius: BorderRadius.circular(4), color: Colors.purple.shade200),
                      Text("${toDoProvider.completedTaskCount} Tasks Completed out of ${toDoProvider.allTasks.length}", style: const TextStyle(fontSize: 12))
                    ]),
                  ),
          ),
          Expanded(
              child: Consumer<ToDoProvider>(
                  builder: (context, toDoProvider, child) => ListView.builder(
                      itemCount: toDoProvider.allTasks.length,
                      itemBuilder: ((context, index) => Visibility(
                          visible: toDoProvider.showCompletedStatus || !jsonDecode(toDoProvider.allTasks[index])["status"],
                          child: ListTile(
                              onTap: () => toDoProvider.toggleTask(index),
                              onLongPress: () => toDoProvider.deleteTask(index),
                              title: Text(jsonDecode(toDoProvider.allTasks[index])["title"]),
                              subtitle: Text(DateTime.fromMillisecondsSinceEpoch(jsonDecode(toDoProvider.allTasks[index])["created_on"]).toString()),
                              leading: Checkbox(value: jsonDecode(toDoProvider.allTasks[index])["status"], onChanged: (value) => toDoProvider.toggleTask(index))))))))
        ]));
  }
}
