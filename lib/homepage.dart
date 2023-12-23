// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud/data/models/user_model.dart';
import 'package:crud/data/remote_data_source/firestore_helper.dart';
import 'package:crud/edit.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CRUD Operations'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'username'),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: _ageController,
              decoration: InputDecoration(
                  border: OutlineInputBorder(), hintText: 'age'),
            ),
            SizedBox(
              height: 20,
            ),


            StreamBuilder<List<UserModel>>(
              stream: FireStoreHelper.read(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if(snapshot.hasError){
                  return Center(child: Text('some error occured'),);
                }

                if(snapshot.hasData){
                  final userData = snapshot.data;
                  return Expanded(
                  child: ListView.builder(
                    itemCount: userData!.length,
                    itemBuilder: (context, index) {
                      final singleUser = userData[index];
                    return  Container(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      onLongPress: () {
                        showDialog(context: context, builder: (context) {
                          return AlertDialog(
                            title: Text('Delete'),
                            content: Text('Are you sure you want to delete'),
                            actions: [
                              ElevatedButton(onPressed: (){
                                FireStoreHelper.delete(singleUser).then((value){
                                  Navigator.pop(context);
                                });}, child: Text('Delete'))
                            ],
                          );
                        },);
                      },
                      leading: Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                          shape: BoxShape.circle
                        ),
                      ),
                      title: Text('${singleUser.username}'),
                      subtitle: Text('${singleUser.age}'),
                      trailing: GestureDetector(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => EditPage(user: UserModel(username: singleUser.username, age: singleUser.age, id: singleUser.id),),));
                        },
                        child: Icon(Icons.edit)),
                    ),
                                    );
                  },),
                );
                }

                return Center(child: CircularProgressIndicator(),);
              }
            )
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          FireStoreHelper.create(UserModel(
              username: _usernameController.text, age: _ageController.text));
          // _create();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  // Future _create() async {
  //   final userCollection = FirebaseFirestore.instance.collection('users');

  //   final docRef = userCollection.doc();

  //   await docRef.set({
  //     'username': _usernameController.text,
  //     'age': _ageController.text
  //   });
  // }

}
