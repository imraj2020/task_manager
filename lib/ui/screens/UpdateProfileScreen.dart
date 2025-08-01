import 'dart:convert';
import 'dart:typed_data';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_manager/Model/User_Model.dart';
import 'package:task_manager/ui/utils/urls.dart';
import '../../Controller/Auth_controller.dart';
import '../../Network/network_caller.dart';
import '../../widget/Center_circular_progress_bar.dart';
import '../../widget/ScreenBackground.dart';
import '../../widget/Snackbar_Messages.dart';
import '../../widget/TDAppBar.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  static const String name = '/update-profile';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _phoneTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ImagePicker _imagePicker = ImagePicker();
  XFile? _selectedImage;
  bool _updateProfileInProgress = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _emailTEController.text = AuthController.userModel?.email ?? '';
      _firstNameTEController.text = AuthController.userModel?.firstName ?? '';
      _lastNameTEController.text = AuthController.userModel?.lastName ?? '';
      _phoneTEController.text = AuthController.userModel?.mobile ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TDAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'Update Profile',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildPhotoPicker(),

                  const SizedBox(height: 8),
                  // TODO: Design photo selector
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _emailTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Email'),
                    validator: (String? value) {
                      String email = value ?? '';
                      if (EmailValidator.validate(email) == false) {
                        return 'Enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _firstNameTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'First name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your first name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _lastNameTEController,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Last name'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your Last name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _phoneTEController,
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(hintText: 'Mobile'),
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'Enter your mobile number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    controller: _passwordTEController,
                    obscureText: _obscurePassword,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                    ),
                    validator: (String? value) {
                      int length = value?.length ?? 0;
                      if (length > 0 && length <= 6) {
                        return 'Enter a password more than 6 letters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  Visibility(
                    visible: _updateProfileInProgress == false,
                    replacement: CenteredCircularProgressIndicator(),
                    child: ElevatedButton(
                      onPressed: _onTapSubmitButton,
                      child: Icon(Icons.arrow_circle_right_outlined),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _onTapPhotoPicker,
      child: Container(
        height: 50,
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
              ),
              alignment: Alignment.center,
              child: Text(
                'Photo',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _selectedImage == null ? 'Select image' : _selectedImage!.name,
              maxLines: 1,
              style: TextStyle(overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _onTapPhotoPicker() async {
    final XFile? pickedImage = await _imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedImage != null) {
      final int fileSizeInBytes = await pickedImage.length();
      final double fileSizeInKB = fileSizeInBytes / 1024;

      if (fileSizeInKB > 64) {
        showSnackBarMessage(
          context,
          'Image is too large. Max allowed size is 64KB.',
        );
        return;
      } else {
        _selectedImage = pickedImage;
        setState(() {});
      }
    } else {
      showSnackBarMessage(context, 'No image selected');
    }
  }

  void _onTapSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _updateProfile();
    }
  }

  Future<void> _updateProfile() async {
    _updateProfileInProgress = true;
    if (mounted) {
      setState(() {});
    }
    Uint8List? imageBytes;

    Map<String, String> requestBody = {
      'email': _emailTEController.text.trim(),
      'firstName': _firstNameTEController.text.trim(),
      'lastName': _lastNameTEController.text.trim(),
      'mobile': _phoneTEController.text.trim(),
    };

    if (_passwordTEController.text.isNotEmpty) {
      requestBody['password'] = _passwordTEController.text;
    }
    if (_selectedImage != null) {
      imageBytes = await _selectedImage!.readAsBytes();
      requestBody['photo'] = base64Encode(imageBytes);
    }

    NetworkResponse response = await networkCaller.postRequest(
      url: urls.UpdateProfileUrl,
      body: requestBody,
    );

    _updateProfileInProgress = false;
    if (mounted) {
      setState(() {});
    }

    if (response.isSuccess) {
      UserModel userModel = UserModel(
        id: AuthController.userModel!.id,
        email: _emailTEController.text.trim(),
        firstName: _firstNameTEController.text.trim(),
        lastName: _lastNameTEController.text.trim(),
        mobile: _phoneTEController.text.trim(),
        photo: imageBytes == null
            ? AuthController.userModel!.photo
            : base64Encode(imageBytes),
      );
      await AuthController.updateUserData(userModel);

      _passwordTEController.clear();
      if (mounted) {
        showSnackBarMessage(context, 'Profile updated');
        setState(() {});
      }
    } else {
      if (mounted) {
        showSnackBarMessage(context, response.errorMessage!);
      }
    }
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _phoneTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
