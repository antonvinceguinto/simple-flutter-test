import 'dart:io';

import 'package:simple_test/utils/imports.dart';

class SimpleController extends GetxController {
  RxBool isLoading = false.obs;

  Future loginUser(
    String email,
    String password,
  ) async {
    try {
      isLoading.value = true;

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      isLoading.value = false;

      await Get.offAll(HomePage());
    } on FirebaseAuthException catch (e) {
      return showGenericAlertDialog(error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future registerUser(UserModel userModel, File imageFile) async {
    try {
      isLoading.value = true;

      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      await uploadImage(userModel, imageFile);
    } on FirebaseAuthException catch (e) {
      return showGenericAlertDialog(error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future uploadImage(UserModel userModel, File imageFile) async {
    final Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('user_images/profile_picture/${userModel.email}/image');

    final UploadTask uploadTask = storageReference.putFile(imageFile);

    try {
      await showDialog(
        context: Get.context,
        barrierDismissible: false,
        builder: (BuildContext dialogContext) {
          Future.delayed(Duration(seconds: 2), () {
            Get.back();
          });

          return AlertDialog(
            title: Text('Uploading image'),
            content: Text('Please wait'),
          );
        },
      );

      final res = await uploadTask;

      if (res.state == TaskState.success) {
        final newProfileUrl = await uploadTask.storage
            .ref()
            .child('user_images/profile_picture/${userModel.email}/image')
            .getDownloadURL();

        userModel.imageUrl = newProfileUrl;

        return await saveUserToFireStore(userModel);
      }
    } on FirebaseException catch (e) {
      return showGenericAlertDialog(error: e);
    } finally {
      isLoading.value = false;
    }
  }

  Future saveUserToFireStore(UserModel userModel) async {
    final CollectionReference userRef =
        FirebaseFirestore.instance.collection('users');

    final Map<String, dynamic> freshUserModel = userModel.toJson();

    await userRef.add(freshUserModel);

    isLoading.value = false;

    await showGenericNormalAlertDialog(
      'SUCCESSFUL',
      'Registration successful',
      onOk: () => Get.back(),
    );
  }
}
