import 'package:get/get.dart';
import 'package:task_manager/Controller/cancelled_task_list_controller.dart';
import '../Controller/completed_task_list_controller.dart';
import '../Controller/new_task_list_controller.dart';
import '../Controller/progress_task_list_controller.dart';
import '../Controller/sign_in_controller.dart';
import '../Controller/task_count_summary_controller.dart';
import '../Controller/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(SignInController());
    Get.put(TaskCountSummaryController());
    Get.put(NewTaskListController());
    Get.put(ProgressTaskListController());
    Get.put(CancelledTaskListController());
    Get.put(CompletedTaskListController());
    Get.put(UpdateProfileController());
  }
}
