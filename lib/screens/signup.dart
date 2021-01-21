import 'dart:io';

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
                              child: Icon(
                                Icons.cloud_upload,
                                size: 13,
                              ),
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
                                  imageFile = File(pickedFile.path);
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.black26,
                                  borderRadius: BorderRadius.circular(100),
                                ),
                                child: Icon(
                                  Icons.cloud_upload,
                                  color: Colors.white,
                                ),
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
                    SizedBox(height: 12),
                    Container(
                      width: context.width,
                      child: RaisedButton(
                        onPressed: () async {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
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
