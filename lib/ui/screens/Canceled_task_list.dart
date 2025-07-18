import 'package:flutter/material.dart';
import 'package:task_manager/Model/Task_Model.dart';
import 'package:task_manager/Network/network_caller.dart';
import 'package:task_manager/ui/utils/urls.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';

import '../../widget/Snackbar_Messages.dart';
import '../../widget/Task_card.dart';
import '../../widget/Task_count_summary_card.dart';

class CanceledTaskList extends StatefulWidget {
  const CanceledTaskList({super.key});

  @override
  State<CanceledTaskList> createState() => _CanceledTaskListState();
}

class _CanceledTaskListState extends State<CanceledTaskList> {

  List<TaskModel> _canceledTaskList = [];
  bool _CancelledTaskisLoading = false;


  @override
  void initState() {

    _getCancelledTaskList();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          children: [
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: ListView.separated(
                itemCount: 4,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return TaskCountSummaryCard(title: 'Progress', count: 12);
                },
                separatorBuilder: (context, index) => const SizedBox(width: 4),
              ),
            ),
            Visibility(
              visible: _CancelledTaskisLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _canceledTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(taskType: TaskType.cancelled,
                      taskModel: _canceledTaskList[index],
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



  Future<void> _getCancelledTaskList() async {

    _CancelledTaskisLoading = true;
    setState(() {});

    NetworkResponse response = await networkCaller.getRequest(url: urls.CancelledTasksUrl);

    if (response.isSuccess) {
      _CancelledTaskisLoading = true;
      final List<TaskModel> list = [];

      for( Map<String, dynamic> jsonData in response.body!['data']){

        list.add(TaskModel.fromJson(jsonData));
      }
      _canceledTaskList = list;

    } else {
      showSnackBarMessage(context, 'Failed to load cancelled tasks: ${response.errorMessage!}');
    }

    _CancelledTaskisLoading= false;
    setState(() {});

  }

  void _onTapAddNewTaskButton() {
    Navigator.pushNamed(context, '/add-new-task');
  }

  @override
  void dispose() {
    super.dispose();
  }
}
