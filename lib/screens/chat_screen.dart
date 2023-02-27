// ignore_for_file: prefer_const_constructors

import 'package:chat_app_with_firebase/widgets/chat/messages.dart';
import 'package:chat_app_with_firebase/widgets/chat/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(
            items: [
              DropdownMenuItem(
                child: Container(
                  child: Row(
                    children: [
                      Icon(Icons.exit_to_app),
                      SizedBox(
                        width: 8,
                      ),
                      Text('Logout'),
                    ],
                  ),
                ),
                value: 'logout',
              )
            ],
            onChanged: (itemIdentifier) {
              if (itemIdentifier == 'logout') {
                FirebaseAuth.instance.signOut();
              }
            },
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).primaryIconTheme.color,
            ),
          )
        ],
      ),
      body: Container(
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Expanded(child: Messages()),
            NewMessage(),
          ],
        ),
      ),
      // StreamBuilder(
      //   stream: FirebaseFirestore.instance
      //       .collection('chats/Z9pFM9wI8bE4e5MmeMEl/messages')
      //       .snapshots(),
      //   builder: (ctx, streamSnapshot) {
      //     if (streamSnapshot.connectionState == ConnectionState.waiting) {
      //       return Center(
      //         child: CircularProgressIndicator(),
      //       );
      //     }
      //     final documents = streamSnapshot.data!.docs;
      //     return ListView.builder(
      //       itemBuilder: (ctx, index) => Container(
      //         padding: EdgeInsets.all(8),
      //         child: Text(documents[index]['text']),
      //       ),
      //       itemCount: documents.length,
      //     );
      //   },
      // ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     FirebaseFirestore.instance
      //         .collection('chats/Z9pFM9wI8bE4e5MmeMEl/messages')
      //         .add({'text': 'This was added by clicking the button!'});
      //async
      // await Firebase.initializeApp();
      // FirebaseFirestore.instance
      //     .collection('chats/Z9pFM9wI8bE4e5MmeMEl/messages')
      //     .snapshots()
      //     .listen((data) {
      //   data.docs.forEach((docs) {
      //     print(docs['text']);
      //   });
      // });
      //   },
      //   child: Icon(Icons.add),
      // ),
    );
  }
}
