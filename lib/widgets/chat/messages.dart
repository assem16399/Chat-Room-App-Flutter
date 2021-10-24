import 'package:chat/widgets/chat/message_bubble.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  bool isMe({String messageUid, currentUid}) {
    if (messageUid == currentUid)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, dataSnapshot) {
        if (dataSnapshot.connectionState == ConnectionState.waiting)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return StreamBuilder(
            stream: Firestore.instance
                .collection('chat')
                .orderBy('createdAt', descending: true)
                .snapshots(),
            builder: (context, chatStreamSnapshot) {
              if (chatStreamSnapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(),
                );
              else if (chatStreamSnapshot.data.documents.length != 0)
                return ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) => MessageBubble(
                    imageUrl: chatStreamSnapshot.data.documents[index]
                        ['userImageUrl'],
                    key: ValueKey(
                        chatStreamSnapshot.data.documents[index].documentID),
                    username: chatStreamSnapshot.data.documents[index]
                        ['username'],
                    isMe: isMe(
                        messageUid: chatStreamSnapshot.data.documents[index]
                            ['userId'],
                        currentUid: dataSnapshot.data.uid),
                    message: chatStreamSnapshot.data.documents[index]['text'],
                  ),
                  itemCount: chatStreamSnapshot.data.documents.length,
                );
              else {
                return Center(
                  child: Text('Start the conversation'),
                );
              }
            },
          );
      },
    );
  }
}
