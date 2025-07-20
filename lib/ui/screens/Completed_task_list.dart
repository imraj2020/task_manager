import 'package:flutter/material.dart';
import 'package:task_manager/ui/utils/urls.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';

import '../../Model/Task_Model.dart';
import '../../Network/network_caller.dart';
import '../../widget/Snackbar_Messages.dart';
import '../../widget/Task_card.dart';
import '../../widget/Task_count_summary_card.dart';

class CompletedTaskList extends StatefulWidget {
  const CompletedTaskList({super.key});

  @override
  State<CompletedTaskList> createState() => _CompletedTaskListState();
}

class _CompletedTaskListState extends State<CompletedTaskList> {

  List<TaskModel> _completedTaskList = [];
  bool _CompletedTaskisLoading = false;

  @override
  void initState() {

    super.initState();
    _CompletedTaskList();
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
              visible: _CompletedTaskisLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: Expanded(
                child: ListView.builder(
                  itemCount: _completedTaskList.length,
                  itemBuilder: (context, index) {
                    return TaskCard(
                      taskType: TaskType.completed,
                      taskModel: _completedTaskList[index],
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

  Future<void> _CompletedTaskList() async {
   _CompletedTaskisLoading = true;
    setState(() {});

    NetworkResponse response = await networkCaller.getRequest(url: urls.CompletedTasksUrl);

    if(response.isSuccess){
      List<TaskModel> list = [];
      for(Map<String, dynamic> jsonData in response.body!['data']){
        list.add(TaskModel.fromJson(jsonData));
      }
      _completedTaskList = list;
    }

    else{

      showSnackBarMessage(context, 'Failed to load completed tasks: ${response.errorMessage!}');
    }

   _CompletedTaskisLoading = false;
   setState(() {});
  }
}
