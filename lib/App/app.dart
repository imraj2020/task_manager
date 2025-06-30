import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/SpalashScreen.dart';
class TaskManager extends StatefulWidget {
  const TaskManager({super.key});

  @override
  State<TaskManager> createState() => _TaskManagerState();
}

class _TaskManagerState extends State<TaskManager> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SpalashScreen(),
    );
  }
}
