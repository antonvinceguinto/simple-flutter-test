import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:simple_test/models/user_model.dart';
import 'package:simple_test/utils/generic_exception.dart';
import 'package:simple_test/utils/imports.dart';

class SimpleController extends GetxController {
  RxBool isLoading = false.obs;

  Future registerUser(UserModel userModel) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      await saveUserToFireStore(userModel);
    } on FirebaseAuthException catch (e) {
      return showGenericAlertDialog(error: e);
    } catch (e) {
      print(e);
    }
  }

  Future saveUserToFireStore(UserModel userModel) async {
    final CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    // TODO: Upload image

    final UserModel userModel = UserModel();

    final Map<String, dynamic> freshUserModel = userModel.toJson();

    await userRef.add(freshUserModel);
  }
}
