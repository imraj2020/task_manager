import 'package:get/get.dart';
import '../Controller/new_task_list_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(NewTaskListController());
  }
}
