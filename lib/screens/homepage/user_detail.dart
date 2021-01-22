import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:simple_test/utils/imports.dart';

class UserDetail extends StatelessWidget {
  UserDetail({
    @required this.userModel,
    @required this.docId,
  });

  final UserModel userModel;
  final String docId;

  final controller = Get.put(HomeController());

  UserModel user;

  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Details'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: CustomStreamBuilder<QuerySnapshot>(
                stream: usersRef.snapshots(),
                child: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  final QueryDocumentSnapshot doc = snapshot.data.docs
                      .firstWhere((element) => element.id == docId);
                  user = UserModel.fromJson(doc.data());

                  return Center(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey.withOpacity(0.1),
                            backgroundImage:
                                CachedNetworkImageProvider(user.imageUrl),
                            radius: 50,
                          ),
                          SizedBox(height: 42),
                          _buildUserInfo('${user.name}'),
                          _buildUserInfo('${user.email}'),
                          _buildUserInfo(
                              '${DateFormat('MMMM dd, yyyy').format(user.birthDate.toDate())}'),
                          _buildUserInfo('${user.contactNumber}'),
                          _buildUserInfo('${user.address}'),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Container(
              width: Get.context.width,
              height: kToolbarHeight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        await controller.editUser(
                          user,
                          docId,
                        );
                      },
                      child: Container(
                        color: Colors.orange,
                        child: Center(
                          child: Text(
                            'EDIT',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () async {
                        Get.back();
                        await controller.deleteUser(
                          user,
                          docId,
                        );
                      },
                      child: Container(
                        color: Colors.red,
                        child: Center(
                          child: Text(
                            'DELETE',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfo(String value) {
    return Container(
      width: Get.context.width,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 42),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(value.toUpperCase()),
    );
  }
}
