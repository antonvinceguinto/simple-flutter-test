import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:simple_test/screens/homepage/user_detail.dart';
import 'package:simple_test/utils/imports.dart';

class HomePage extends StatelessWidget {
  final controller = Get.put(HomeController());
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
        actions: [
          InkWell(
            onTap: () async => await Get.to(SignUp()),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text('Sign up'),
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: CustomStreamBuilder<QuerySnapshot>(
          stream: usersRef.snapshots(),
          child: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            final List<QueryDocumentSnapshot> docs = snapshot.data.docs;

            List<UserModel> users = [];

            for (var doc in docs) {
              users.add(UserModel.fromJson(doc.data()));
            }

            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, i) {
                final UserModel user = users[i];

                final formattedDate =
                    DateFormat('MMMM dd, yyyy').format(user.birthDate.toDate());

                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  secondaryActions: <Widget>[
                    IconSlideAction(
                      caption: 'Edit',
                      color: Colors.blue,
                      icon: Icons.create,
                      onTap: () async => controller.editUser(
                        user,
                        docs[i].id,
                      ),
                    ),
                    IconSlideAction(
                      caption: 'Delete',
                      color: Colors.red,
                      icon: Icons.delete,
                      onTap: () async => controller.deleteUser(
                        user,
                        docs[i].id,
                      ),
                    ),
                  ],
                  child: Container(
                    child: ListTile(
                      onTap: () async => await Get.to(
                        UserDetail(
                          userModel: user,
                          docId: docs[i].id,
                        ),
                      ),
                      title: Text(
                        '${user.name}'.toUpperCase(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('$formattedDate'),
                          Text('(+63) ${user.contactNumber}'),
                        ],
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                            CachedNetworkImageProvider(user.imageUrl),
                      ),
                      trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text('${user.email}'),
                          Text('${user.address}'),
                        ],
                      ),
                      isThreeLine: true,
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
