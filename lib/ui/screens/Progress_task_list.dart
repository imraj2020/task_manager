import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:task_manager/Network/network_caller.dart';
import 'package:task_manager/ui/screens/Add_new_task_screen.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';

import '../../Model/Task_Model.dart';
import '../../Network/Task_Count_Network_Call.dart';
import '../../widget/Snackbar_Messages.dart';
import '../../widget/Task_card.dart';
import '../../widget/Task_count_summary_card.dart';
import '../utils/urls.dart';

class ProgressTaskList extends StatefulWidget {
  const ProgressTaskList({super.key});

  @override
  State<ProgressTaskList> createState() => _ProgressTaskListState();
}

class _ProgressTaskListState extends State<ProgressTaskList> {
  bool _ProgressTaskisLoading = false;
  List<TaskModel> _progressTaskList = [];

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getProgressTaskList();
      TaskCountNetworkCall.TaskCountSummary();
    }

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
              visible: TaskCountNetworkCall.taskSummaryLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: TaskCountNetworkCall.taskSummaryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountSummaryCard(
                      title: TaskCountNetworkCall.taskSummaryList
                          .elementAt(index)
                          .sId!,
                      count: TaskCountNetworkCall.taskSummaryList
                          .elementAt(index)
                          .sum!,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                ),
              ),
            ),
            Visibility(
              visible: _ProgressTaskisLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _progressTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskType: TaskType.progress,
                      taskModel: _progressTaskList[index],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getProgressTaskList() async {
    _ProgressTaskisLoading = true;
    setState(() {});
    NetworkResponse response = await networkCaller.getRequest(
      url: urls.ProgressTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskModel> list = [];

      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskModel.fromJson(jsonData));
      }
      _progressTaskList = list;
    } else {
      showSnackBarMessage(context, response.errorMessage!);
    }

    _ProgressTaskisLoading = false;
    setState(() {});
  }
}
