import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../Model/Task_Model.dart';
import '../Network/network_caller.dart';
import '../ui/utils/urls.dart';
import '../widget/Snackbar_Messages.dart';

class TaskCardController extends GetxController {
  final TaskModel taskModel;

  TaskCardController({required this.taskModel});

  bool _updateTaskStatusInProgress = false;
  bool _deleteTaskInProgress = false;
  String? _errorMessage;

  bool get updateTaskStatusInProgress => _updateTaskStatusInProgress;

  bool get deleteTaskInProgress => _deleteTaskInProgress;

  String? get errorMessage => _errorMessage;

  Future<void> updateTaskStatus(
    String status,
    BuildContext context,
    VoidCallback onTaskStatusUpdated,
  ) async {
    _updateTaskStatusInProgress = true;

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.UpdateTaskStatusUrl(taskModel.id!, status),
    );

    _updateTaskStatusInProgress = false;

    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task status updated');
      _errorMessage = null;
      Get.back();
      onTaskStatusUpdated();
      update();
    } else {
      _updateTaskStatusInProgress = false;
      showSnackBarMessage(
        context,
        'Failed to update task status: ${response.errorMessage!}',
      );
      _errorMessage = response.errorMessage!;
      update();
    }

    _updateTaskStatusInProgress = false;
    update();
  }

  Future<void> deleteTask(
    VoidCallback onDeleteTask,
    BuildContext context,
  ) async {
    _deleteTaskInProgress = true;

    NetworkResponse response = await networkCaller.getRequest(
      url: urls.DeleteTaskUrl(taskModel.id),
    );

    _deleteTaskInProgress = false;

    if (response.isSuccess && response.body?['status'] == 'success') {
      _errorMessage = null;
      Get.back();
      onDeleteTask();
      update();
      showSnackBarMessage(context, 'Task deleted');
    } else {
      _deleteTaskInProgress = false;
      _errorMessage = response.errorMessage ?? 'Failed to delete task';
      update();
      showSnackBarMessage(context, "Failed to delete task");
    }

    _deleteTaskInProgress = false;
    update();
  }
}
