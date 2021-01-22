import 'package:intl/intl.dart';
import 'package:simple_test/utils/imports.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;

  Future deleteUser(UserModel user, String docId) async {
    try {
      CollectionReference users =
          FirebaseFirestore.instance.collection('users');

      await showDialog<void>(
        context: Get.context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Delete'),
            content: Text('Remove ${user.name}?'),
            actions: <Widget>[
              FlatButton(
                child: Text(
                  'CANCEL',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
                onPressed: () => Get.back(),
              ),
              FlatButton(
                child: Text('DELETE'),
                onPressed: () async {
                  await users.doc(docId).delete();
                  Get.back();
                  Get.rawSnackbar(message: 'Deleted ${user.name}');
                },
              ),
            ],
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      return showGenericAlertDialog(error: e);
    }
  }

  Future editUser(UserModel user, String docId) async {
    try {
      final DocumentReference documentReference =
          FirebaseFirestore.instance.collection('users').doc(docId);

      emailFieldController.text = user.email;
      passwordFieldController.text = user.password;
      nameFieldController.text = user.name;
      addressFieldController.text = user.address;
      contactFieldController.text = user.contactNumber.toString();
      birthDate = user.birthDate.toDate();

      await showDialog<void>(
        context: Get.context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            title: Text('Edit details'),
            content: StatefulBuilder(
              builder: (BuildContext context,
                  void Function(void Function()) setState) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 100,
                          child: CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            backgroundImage:
                                CachedNetworkImageProvider(user.imageUrl),
                            radius: 50,
                          ),
                        ),
                        IgnorePointer(
                          ignoring: true,
                          child: _buildTextField(
                            emailFieldController,
                            'Email',
                          ),
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
                              onPressed: isLoading.value
                                  ? null
                                  : () async {
                                      if (birthDate == null) {
                                        return Get.rawSnackbar(
                                            message:
                                                'Please enter your birthdate');
                                      }

                                      final UserModel userModel = UserModel(
                                        email: emailFieldController.text.trim(),
                                        password:
                                            passwordFieldController.text.trim(),
                                        name: nameFieldController.text.trim(),
                                        address:
                                            addressFieldController.text.trim(),
                                        contactNumber: int.parse(
                                            contactFieldController.text.trim()),
                                        birthDate:
                                            Timestamp.fromDate(birthDate),
                                      );

                                      userModel.imageUrl = user.imageUrl;

                                      await FirebaseFirestore.instance
                                          .runTransaction((Transaction
                                              myTransaction) async {
                                        myTransaction.update(
                                          documentReference,
                                          userModel.toJson(),
                                        );
                                      });

                                      Get.back();
                                    },
                              color: Colors.redAccent,
                              child: Text(
                                'SAVE',
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
                );
              },
            ),
          );
        },
      );
    } on FirebaseAuthException catch (e) {
      return showGenericAlertDialog(error: e);
    }
  }

  final TextEditingController emailFieldController = TextEditingController();
  final TextEditingController passwordFieldController = TextEditingController();
  final TextEditingController nameFieldController = TextEditingController();
  final TextEditingController addressFieldController = TextEditingController();
  final TextEditingController contactFieldController = TextEditingController();

  DateTime birthDate;
  final dateFormat = DateFormat('MMMM dd, yyyy');

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
