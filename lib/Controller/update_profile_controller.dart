import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/Controller/Auth_controller.dart';
import 'package:task_manager/Model/User_Model.dart';
import 'package:task_manager/Network/network_caller.dart';
import 'package:task_manager/ui/utils/urls.dart';
import '../widget/Snackbar_Messages.dart';

class UpdateProfileController extends GetxController {
  final email = TextEditingController();
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final phone = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _isLoading = false;
  XFile? selectedImage;
  final imagePicker = ImagePicker();

  bool get isLoading => _isLoading;

  bool get obscurePassword => _obscurePassword;

  set obscurePassword(bool value) {
    _obscurePassword = value;
    update();
  }

  @override
  void onInit() {
    final user = AuthController.userModel;
    email.text = user?.email ?? '';
    firstName.text = user?.firstName ?? '';
    lastName.text = user?.lastName ?? '';
    phone.text = user?.mobile ?? '';
    super.onInit();
  }

  void togglePasswordVisibility() {
    obscurePassword = !obscurePassword;
    update();
  }

  Future<void> pickImage(BuildContext context) async {
    final picked = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      final fileSizeInBytes = await picked.length();
      final sizeKB = fileSizeInBytes / 1024;

      if (sizeKB > 64) {
        showSnackBarMessage(
          context,
          'Image is too large. Max allowed size is 64KB.',
        );
        return;
      }
      selectedImage = picked;
    } else {
      showSnackBarMessage(context, 'No image selected');
    }
    update();
  }

  Future<void> submit(BuildContext context) async {
    if (!formKey.currentState!.validate()) return;
    _isLoading = true;
    update();

    Uint8List? imageBytes;
    final body = {
      'email': email.text.trim(),
      'firstName': firstName.text.trim(),
      'lastName': lastName.text.trim(),
      'mobile': phone.text.trim(),
    };

    if (password.text.isNotEmpty) {
      body['password'] = password.text;
    }

    if (selectedImage != null) {
      imageBytes = await selectedImage!.readAsBytes();
      body['photo'] = base64Encode(imageBytes);
    }

    final response = await networkCaller.postRequest(
      url: urls.UpdateProfileUrl,
      body: body,
    );

    if (response.isSuccess) {
      final updatedUser = UserModel(
        id: AuthController.userModel!.id,
        email: email.text.trim(),
        firstName: firstName.text.trim(),
        lastName: lastName.text.trim(),
        mobile: phone.text.trim(),
        photo: imageBytes == null
            ? AuthController.userModel!.photo
            : base64Encode(imageBytes),
      );
      await AuthController.updateUserData(updatedUser);
      password.clear();
      showSnackBarMessage(context, 'Profile updated');
    } else {
      showSnackBarMessage(context, response.errorMessage ?? '');
    }
    _isLoading = false;
    update();
  }

  @override
  void onClose() {
    email.dispose();
    firstName.dispose();
    lastName.dispose();
    phone.dispose();
    password.dispose();
    super.onClose();
  }
}
