import 'package:chat_box_using_firebase/widget/chat_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final Map<String, dynamic> userMap;

  const ChatRoom({Key? key, required this.chatRoomId, required this.userMap})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  TextEditingController messageController = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void onSendingMessage() async {
    if (messageController.text.isNotEmpty) {
      Map<String, dynamic> message = {
        'sendBy': auth.currentUser!.displayName,
        'message': messageController.text,
        'time': FieldValue.serverTimestamp()
      };

      await firestore
          .collection('chatRoom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(message);

      messageController.clear();
    } else {
      debugPrint('Enter some text');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.userMap['name']),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Container(
                height: size.height / 1.25,
                width: size.width,
                child: StreamBuilder(
                    stream: firestore
                        .collection('chatRoom')
                        .doc(widget.chatRoomId)
                        .collection('chats')
                        .orderBy('time', descending: false)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.data != null) {
                        return ListView.builder(
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              Map <String , dynamic> map = snapshot.data!.docs[index].data() as Map<String , dynamic>;
                              return ChatTile(size: size, map: map);
                            });
                      } else {
                        return Container();
                      }
                    })),
            Container(
              height: size.height / 10,
              width: size.width,
              alignment: Alignment.center,
              child: SizedBox(
                height: size.height / 12,
                width: size.width / 1.1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: size.height / 12,
                      width: size.width / 1.5,
                      child: TextField(
                        controller: messageController,
                        decoration: InputDecoration(
                            hintText: 'Enter a message',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0))),
                      ),
                    ),
                    IconButton(
                        onPressed: onSendingMessage,
                        icon: const Icon(Icons.send_rounded))
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      /*bottomNavigationBar: Container(
        height: size.height / 10,
        width: size.width,
        alignment: Alignment.center,
        child: SizedBox(
          height: size.height / 12,
          width: size.width / 1.1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: size.height / 12,
                width: size.width / 1.5,
                child: TextField(
                  controller: messageController,
                  decoration: InputDecoration(
                    hintText: 'Enter a message',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0))),
                ),
              ),
              IconButton(onPressed: () {}, icon: const Icon(Icons.send_rounded))
            ],
          ),
        ),
      )*/
    );
  }
}
