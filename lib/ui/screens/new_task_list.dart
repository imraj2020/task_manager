import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Model/Task_Model.dart';
import 'package:task_manager/Model/Task_Status_Count_Model.dart';
import 'package:task_manager/Network/network_caller.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';

import '../../widget/Snackbar_Messages.dart';
import '../../widget/Task_card.dart';
import '../../widget/Task_count_summary_card.dart';
import '../utils/urls.dart';

class NewTaskList extends StatefulWidget {
  const NewTaskList({super.key});

  @override
  State<NewTaskList> createState() => _NewTaskListState();
  static const String name = '/new-task-list';
}

class _NewTaskListState extends State<NewTaskList> {
  List<TaskModel> _newTaskList = [];
  bool _isLoading = true;



  @override
  void initState() {
    super.initState();

    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),

            Visibility(
              visible: _isLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _newTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskType: TaskType.tNew,
                      taskModel: _newTaskList[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onTapAddNewTaskButton,
        child: Icon(Icons.add),
      ),
    );
  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, '/add-new-task');
  }

  Future<void> _getNewTaskList() async {
    _isLoading = true;
    setState(() {});

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token') ?? '';

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.GetNewTasksUrl,
    );
    if (response.isSuccess) {
      List<TaskModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _newTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

    _isLoading = false;
    setState(() {});
  }


}
