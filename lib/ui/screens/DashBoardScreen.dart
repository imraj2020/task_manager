import 'package:flutter/material.dart';
import 'package:task_manager/ui/screens/new_task_list.dart';

import '../../widget/TDAppBar.dart';
import 'Canceled_task_list.dart';
import 'Completed_task_list.dart';
import 'Progress_task_list.dart';

class Dashboardscreen extends StatefulWidget {
  const Dashboardscreen({super.key});

  static const String name = '/dashboard';

  @override
  State<Dashboardscreen> createState() => _DashboardscreenState();
}

class _DashboardscreenState extends State<Dashboardscreen> {
  final List<Widget> _screens = [
    NewTaskList(),
    ProgressTaskList(),
    CompletedTaskList(),
    CanceledTaskList(),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(),
      body: _screens[_selectedIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          _selectedIndex = index;
          setState(() {});
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
}
