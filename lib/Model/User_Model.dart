class UserModel {

  String? id;
  String? email;
  String ? firstName;
  String ? lastName;
  String? mobile;


  String get Fullname {
    return '$firstName $lastName';
  }



  UserModel.fromJson(Map<String, dynamic> json) {

    id = json['id'];
    email = json['email'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    mobile = json['mobile'];
  }

  Map<String, dynamic> toJson() {

    return{
      'id': id,
      'email': email,
      'firstName': firstName,
      'lastName': lastName,
      'mobile': mobile,
    };
  }
}