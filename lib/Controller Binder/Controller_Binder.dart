import 'package:get/get.dart';
import '../Controller/new_task_list_controller.dart';
import '../Controller/task_count_summary_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(NewTaskListController());
    Get.put(TaskCountSummaryController());
  }
}
