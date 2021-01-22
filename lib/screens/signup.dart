import 'dart:io';

import 'package:intl/intl.dart';
import 'package:simple_test/models/user_model.dart';
import 'package:simple_test/utils/imports.dart';

class SignUp extends StatefulWidget {
  const SignUp();

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(SimpleController());

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController addressFieldController = TextEditingController();
  final TextEditingController contactFieldController = TextEditingController();

  final picker = ImagePicker();
  File imageFile;

  DateTime birthDate;
  final dateFormat = DateFormat('MMMM dd, yyyy');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(42),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.1),
                              backgroundImage: imageFile == null
                                  ? null
                                  : FileImage(imageFile),
                              radius: 50,
                            ),
                          ),
                          Positioned.fill(
                            child: InkWell(
                              onTap: () async {
                                final pickedFile = await picker.getImage(
                                    source: ImageSource.gallery);

                                if (pickedFile != null) {
                                  setState(() {
                                    imageFile = File(pickedFile.path);
                                  });
                                }
                              },
                              child: Container(
                                decoration: imageFile == null
                                    ? BoxDecoration(
                                        color: Colors.black26,
                                        borderRadius:
                                            BorderRadius.circular(100),
                                      )
                                    : null,
                                child: imageFile == null
                                    ? Icon(
                                        Icons.cloud_upload,
                                        color: Colors.white,
                                      )
                                    : SizedBox(),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildTextField(
                      emailFieldController,
                      'Email',
                    ),
                    _buildTextField(
                      passwordFieldController,
                      'Password',
                    ),
                    _buildTextField(
                      nameFieldController,
                      'Full name',
                    ),
                    _buildTextField(
                      addressFieldController,
                      'Address',
                    ),
                    _buildTextField(
                      contactFieldController,
                      'Contact Number',
                    ),
                    SizedBox(height: 16),
                    InkWell(
                      onTap: () async {
                        final selectedDate = await showAdaptiveDatePicker(
                          firstDateTime: DateTime(1990),
                          initialDateTime: DateTime.now(),
                          lastDateTime: DateTime.now(),
                        );

                        if (selectedDate != null) {
                          setState(() {
                            birthDate = selectedDate;
                          });
                        }
                      },
                      child: Container(
                        height: 50,
                        width: context.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.only(left: 16),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            birthDate == null
                                ? 'Select Birthdate'
                                : dateFormat.format(birthDate),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    Container(
                      width: context.width,
                      child: Obx(
                        () => RaisedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () async {
                                  if (!_formKey.currentState.validate()) {
                                    return;
                                  }

                                  if (birthDate == null) {
                                    return Get.rawSnackbar(
                                        message: 'Please enter your birthdate');
                                  }

                                  if (imageFile == null) {
                                    return Get.rawSnackbar(
                                        message:
                                            'Please select a profile picture');
                                  }

                                  final UserModel userModel = UserModel(
                                    email: emailFieldController.text.trim(),
                                    password:
                                        passwordFieldController.text.trim(),
                                    name: nameFieldController.text.trim(),
                                    address: addressFieldController.text.trim(),
                                    contactNumber: int.parse(
                                        contactFieldController.text.trim()),
                                    birthDate: Timestamp.fromDate(birthDate),
                                  );

                                  await controller.registerUser(
                                      userModel, imageFile);
                                },
                          color: Colors.redAccent,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController editingController, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: TextFormField(
        controller: editingController,
        validator: (val) {
          return Validator.validate(
            text: val,
            rules: ['required'],
          );
        },
        obscureText: editingController == passwordFieldController,
        keyboardType: editingController == contactFieldController
            ? TextInputType.number
            : TextInputType.text,
        inputFormatters: editingController == contactFieldController
            ? [
                DecimalTextInputFormatter(
                  activatedNegativeValues: false,
                  decimalRange: 0,
                ),
              ]
            : [],
        decoration: InputDecoration(
          labelText: label,
        ),
      ),
    );
  }
}
