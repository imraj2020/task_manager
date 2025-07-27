import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_manager/Controller/new_task_list_controller.dart';
import 'package:task_manager/Model/Task_Model.dart';
import 'package:task_manager/Model/Task_Status_Count_Model.dart';
import 'package:task_manager/Network/network_caller.dart';
import 'package:task_manager/ui/screens/Add_new_task_screen.dart';
import 'package:task_manager/widget/Center_circular_progress_bar.dart';

import '../../widget/Snackbar_Messages.dart';
import '../../widget/Task_card.dart';
import '../../widget/Task_count_summary_card.dart';
import '../utils/DateFormat.dart';
import '../utils/urls.dart';
import 'Show_Task_Details.dart';

class NewTaskList extends StatefulWidget {
  const NewTaskList({super.key});

  @override
  State<NewTaskList> createState() => _NewTaskListState();
  static const String name = '/new-task-list';
}

class _NewTaskListState extends State<NewTaskList> {


  bool _taskCountSummaryLoading = false;
  List<TaskStatusCountModel> _taskCountSummaryList = [];
  // NewTaskListController _newTaskListController = NewTaskListController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
     Get.find<NewTaskListController>().getNewTaskList();
      _getTaskCountSummary();
    });
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
              visible: _taskCountSummaryLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: SizedBox(
                height: 100,
                child: ListView.separated(
                  itemCount: _taskCountSummaryList.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return TaskCountSummaryCard(
                      title: _taskCountSummaryList[index].sId!,
                      count: _taskCountSummaryList[index].sum!,
                    );
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 4),
                ),
              ),
            ),

              GetBuilder<NewTaskListController>(
                builder: (controller) {
                  return Visibility(
                    visible: controller.isLoading == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: Expanded(

                      child: ListView.builder(
                        padding: EdgeInsets.only(bottom: 70),
                        itemCount: controller.newTaskList.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ShowTaskDetails(
                                    title: controller.newTaskList[index].title!,
                                    description: controller.newTaskList[index].description!,
                                    createdDate: formatDate(controller.newTaskList[index].createdDate!),
                                    status:controller.newTaskList[index].status!,
                                  ),
                                ),
                              );
                            },
                            child: TaskCard(
                              taskType: TaskType.tNew,
                              taskModel: controller.newTaskList[index],
                              onTaskStatusUpdated: () {
                                _getTaskCountSummary();
                                Get.find<NewTaskListController>().getNewTaskList();
                              },
                              onDeleteTask: () {
                                _getTaskCountSummary();
                                Get.find<NewTaskListController>().getNewTaskList();
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  );
                }
              ),
          ],
        ),

      ),

    );
  }



  Future<void> _getTaskCountSummary() async {
    _taskCountSummaryLoading = true;

    if (mounted) {
      setState(() {});
    }

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.GetAllTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }
      list.sort((a, b) => b.sum!.compareTo(a.sum!));
      _taskCountSummaryList = list;
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }

    _taskCountSummaryLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
