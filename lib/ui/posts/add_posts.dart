import 'dart:html';

import 'package:firebase_database/firebase_database.dart';
import 'package:firebassapp/utils/utils.dart';
import 'package:firebassapp/widgets/round_button.dart';
import 'package:flutter/material.dart';


class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  
  final postController = TextEditingController();

  bool loading = false;

  final databaseRef = FirebaseDatabase.instance.ref('Post');


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Add Number or User Id'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(
              height: 30,

            ),
            TextFormField(
              maxLines: 2,
              controller: postController,
              decoration: InputDecoration(
                hintText: 'Add Phoneno or UserId',
                border: OutlineInputBorder()

              ),

            ),
            RoundButton(title: 'Add',
                loading: loading,
                onTap: (){
              setState(() {
                loading = true;
              });
              databaseRef.child(DateTime.now().microsecondsSinceEpoch.toString()).set({
                'Title' : postController.text.toString(),
                'Id' : DateTime.now().millisecondsSinceEpoch.toString()
              }).then((value){
                
                Utils().toastMessage('Number/ UserId Added');
                setState(() {
                  loading = false;
                });

              }).onError((error, stackTrace){
                Utils().toastMessage(error.toString());
                setState(() {
                  loading = false;
                });
              });

            })

          ],

        ),
      ),

    );
  }
}
