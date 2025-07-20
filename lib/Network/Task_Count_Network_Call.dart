import '../Model/Task_Status_Count_Model.dart';
import '../ui/utils/urls.dart';
import 'network_caller.dart';

class TaskCountNetworkCall {
  static late bool taskSummaryLoading;

  static var taskSummaryList;

  static Future<List<TaskStatusCountModel>> TaskCountSummary() async {

    taskSummaryLoading = true;
    NetworkResponse response = await networkCaller.getRequest(
      url: urls.GetAllTasksUrl,
    );

    if (response.isSuccess) {
      List<TaskStatusCountModel> list = [];
      for (Map<String, dynamic> jsonData in response.body!['data']) {
        list.add(TaskStatusCountModel.fromJson(jsonData));
      }

      list.sort((a, b) => b.sum!.compareTo(a.sum!));
      taskSummaryList = list;
      taskSummaryLoading = false;
      return taskSummaryList;

    } else {
      taskSummaryLoading = false;
      throw Exception(response.errorMessage ?? "Something went wrong");
    }
  }
}