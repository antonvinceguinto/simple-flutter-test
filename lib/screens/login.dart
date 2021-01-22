import 'package:simple_test/utils/imports.dart';

class Login extends StatefulWidget {
  const Login();

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();

  final controller = Get.put(SimpleController());

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(42),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextFormField(
                  controller: emailFieldController,
                  validator: (val) {
                    return Validator.validate(
                      text: val,
                      rules: ['required'],
                    );
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                ),
                TextFormField(
                  controller: passwordFieldController,
                  validator: (val) {
                    return Validator.validate(
                      text: val,
                      rules: ['required'],
                    );
                  },
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
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
                              await controller.loginUser(
                                emailFieldController.text,
                                passwordFieldController.text,
                              );
                            },
                      color: Colors.redAccent,
                      child: Text(
                        'Login',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: context.width,
                  child: FlatButton(
                    onPressed: () async => await Get.to(SignUp()),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
