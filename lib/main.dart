import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(debugShowCheckedModeBanner: false, title: 'ToDos', theme: ThemeData(useMaterial3: true), home: const TodoPage());
}

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ToDo"),
        actions: [Text("Show Completed"), Switch(value: false, onChanged: (value) {})],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: TextField(
              autofocus: true,
              controller: TextEditingController(),
              onSubmitted: (value) {},
              decoration: InputDecoration(suffixIcon: IconButton(onPressed: () {}, icon: Icon(Icons.adaptive.arrow_forward), iconSize: 18)),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: 20,
                  itemBuilder: ((context, index) => ListTile(
                        onTap: () {},
                        onLongPress: () {},
                        title: Text("Hello $index"),
                        subtitle: Text("Created on"),
                        leading: Checkbox(value: false, onChanged: (value) {}),
                      ))))
        ],
      ),
    );
  }
}
