class EmailVerificationDataModel {
  late String status;
  late String data;

  EmailVerificationDataModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    data = jsonData['data'];
  }
}
