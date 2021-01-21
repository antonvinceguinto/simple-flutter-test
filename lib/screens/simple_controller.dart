import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:simple_test/models/user_model.dart';
import 'package:simple_test/utils/generic_exception.dart';
import 'package:simple_test/utils/imports.dart';

class SimpleController extends GetxController {
  RxBool isLoading = false.obs;

  Future registerUser(UserModel userModel) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );
    } on FirebaseAuthException catch (e) {
      return showGenericAlertDialog(error: e);
    } catch (e) {
      print(e);
    }
  }

  Future saveUserToFireStore(UserModel userModel) async {
    final FirebaseFirestore fireStore = FirebaseFirestore.instance;

    final CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    final UserModel userModel = UserModel();

    final Map<String, dynamic> freshUserModel = userModel.toJson();

    final fireRef = await userRef.add(freshUserModel);

    final DocumentReference documentReference =
        fireStore.collection('users').doc(fireRef.id);

    await FirebaseFirestore.instance
        .runTransaction((Transaction myTransaction) async {
      myTransaction.update(
        documentReference,
        {'fireId': fireRef.id},
      );
    });
  }
}
