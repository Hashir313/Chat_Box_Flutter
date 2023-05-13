import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatTile extends StatefulWidget {
  final Size size;
  final Map<String, dynamic> map;

  const ChatTile({Key? key, required this.size, required this.map})
      : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile> {
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: widget.size.width,
        alignment: widget.map['sendBy'] == auth.currentUser!.displayName
            ? Alignment.centerRight
            : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 14.0),
          margin: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0),
            color: Colors.blue
          ),
          child: Text(
            widget.map['message'],
            style: const TextStyle(color: Colors.white , fontSize: 16.0),
          ),
        ));
  }
}
