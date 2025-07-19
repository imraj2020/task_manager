import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/new_task_list.dart';
import 'package:task_manager/widget/Task_count_summary_card.dart';

import '../../Model/Task_Status_Count_Model.dart';
import '../../Network/network_caller.dart';
import '../../widget/Center_circular_progress_bar.dart';
import '../../widget/Snackbar_Messages.dart';
import '../../widget/TDAppBar.dart';
import '../utils/urls.dart';
import 'Canceled_task_list.dart';
import 'Completed_task_list.dart';
import 'Progress_task_list.dart';

class MainNavbarScreen extends StatefulWidget {
  const MainNavbarScreen({super.key});

  static const String name = '/main-nav-bar-holder';

  @override
  State<MainNavbarScreen> createState() => _MainNavbarScreenState();
}

class _MainNavbarScreenState extends State<MainNavbarScreen> {
  final List<Widget> _screens = [
    NewTaskList(),
    ProgressTaskList(),
    CompletedTaskList(),
    CanceledTaskList(),
  ];

  int _selectedIndex = 0;
  List<TaskStatusCountModel> _taskSummaryList = [];
  bool _taskSummaryLoading = true;


  @override
  void initState() {
    super.initState();
    _TaskCountSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: Visibility(
              visible: _taskSummaryLoading == false,
              replacement: CenteredCircularProgressIndicator(),
              child: ListView.separated(
                itemCount: _taskSummaryList.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return TaskCountSummaryCard(
                    title: _taskSummaryList[index].sId!,
                    count: _taskSummaryList[index].sum!,
                  );
                },
                separatorBuilder: (context, index) =>
                const SizedBox(width: 4),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.new_label_outlined),
            label: 'New',
          ),
          NavigationDestination(
            icon: Icon(Icons.arrow_circle_right_outlined),
            label: 'Progress',
          ),
          NavigationDestination(icon: Icon(Icons.done), label: 'Completed'),
          NavigationDestination(icon: Icon(Icons.close), label: 'Cancelled'),
        ],
      ),
    );
  }

  Future<void> _TaskCountSummary() async {
    _taskSummaryLoading = true;
    setState(() {});
    NetworkResponse response = await networkCaller.getRequest(
      url: urls.GetAllTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }

      list.sort((a, b) => b.sum!.compareTo(a.sum!));
      _taskSummaryList = list;
    } else {
      showSnackBarMessage(
        context,
        response.errorMessage ?? "Something went wrong",
      );
    }
    _taskSummaryLoading = false;
    setState(() {});
  }
}
