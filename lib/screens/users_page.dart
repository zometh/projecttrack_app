import 'package:diop_mouhamed_l3gl_examen/widgets/loading.dart';
import 'package:flutter/material.dart';

import '../models/my_user.dart';
import '../services/firestore_db.dart';
import '../widgets/custom_text.dart';
import '../widgets/user_tile.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("LES UTILISATEURS"),
        centerTitle: true,
      ),
      body: StreamBuilder(

          stream: FirestoreDb().getAllUsers(),
          builder: (_, snapshots){
            if(snapshots.connectionState == ConnectionState.waiting){
              return loadingComponent;
            }
            if(!snapshots.hasData || snapshots.data == null){
              return Center(child: CustomText(text: "Auncune information trouvée !"),);
            }
            List<MyUser> users = snapshots.data!;
            return ListView.builder(
              itemCount: users.length,
              itemBuilder: (_, index){
                return UserTile(user: users[index]);
              }
            );
          }
      ),
    );
  }
}
