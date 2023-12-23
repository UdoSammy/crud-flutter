

// ignore_for_file: prefer_const_constructors

import 'package:crud/data/models/user_model.dart';
import 'package:crud/data/remote_data_source/firestore_helper.dart';
import 'package:flutter/material.dart';

class EditPage extends StatefulWidget {
  final UserModel user;
  EditPage({required this.user});

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {

  TextEditingController? _usernameController;
  TextEditingController? _ageController;


  @override
  void initState() {
    _usernameController = TextEditingController(text: widget.user.username);
    _ageController = TextEditingController(text: widget.user.age);
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    _usernameController!.dispose();
    _ageController!.dispose();

    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Edit'),
        ),

        body: Padding(
          padding: EdgeInsets.all(8),
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

            ElevatedButton(
              onPressed:(){
                FireStoreHelper.update(UserModel(id: widget.user.id, username: _usernameController!.text, age: _ageController!.text),).then((value){
                  Navigator.pop(context);
                });
              },
               child:Text('Update')
            )
            ],
          ),
        ),
      ),
    );
  }
}