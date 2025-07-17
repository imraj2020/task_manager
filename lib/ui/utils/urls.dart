
class urls{

  static const String baseUrl = "http://35.73.30.144:2005/api/v1";
  static const String SignupUrl = "$baseUrl/Registration";
  static const String LoginUrl = "$baseUrl/Login";
  static const String AddNewTaskUrl = "$baseUrl/createTask";
  static const String GetNewTasksUrl = "$baseUrl/listTaskByStatus/New";
  static const String ProgressTasksUrl = "$baseUrl/listTaskByStatus/Progress";
  static const String CancelledTasksUrl = "$baseUrl/listTaskByStatus/Cancelled";
  static const String CompletedTasksUrl = "$baseUrl/listTaskByStatus/Completed";

  // Add more endpoints as needed


}