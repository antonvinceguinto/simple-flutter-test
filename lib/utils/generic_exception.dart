import 'package:simple_test/utils/imports.dart';

Future showGenericAlertDialog({@required FirebaseAuthException error}) async {
  assert(error != null);

  // The user has possibly moved to a different widget. Proceeding further will
  // cause a crash since the original context is no longer available.
  if (Get.context == null) {
    return;
  }

  try {
    await showAdaptiveDialog(
      context: Get.context,
      barrierDismissible: false,
      builder: (context) {
        String errMsg = '';

        switch (error.code) {
          case 'account-exists-with-different-credential':
            errMsg = 'Account already exists';
            break;
          case 'email-already-in-use':
            errMsg = 'Email already used. Go to login page.';
            break;
          case 'wrong-password':
            errMsg = 'Wrong email/password combination.';
            break;
          case 'user-not-found':
            errMsg = 'No user found with this email.';
            break;
          case 'user-disabled':
            errMsg = 'User disabled.';
            break;
          case 'operation-not-allowed':
            errMsg = 'Too many requests to log into this account.';
            break;
          case 'operation-not-allowed':
            errMsg = 'Server error, please try again later.';
            break;
          case 'invalid-email':
            errMsg = 'Email address is invalid.';
            break;
          case 'user-not-found':
            errMsg = 'No account found with this email';
            break;
          default:
            errMsg = 'Login failed. Please try again.';
            break;
        }

        return AdaptiveAlertDialog(
          title: Text('Somehting went wrong'),
          content: SingleChildScrollView(child: Text('$errMsg')),
          actions: <Widget>[
            AdaptiveDialogAction(
              child: Text('OK'),
              onPressed: () => Get.back(),
            )
          ],
        );
      },
    );
  } on FlutterError catch (error) {
    print(error);
  }
}
