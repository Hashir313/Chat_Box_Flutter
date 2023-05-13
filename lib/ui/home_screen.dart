import 'package:chat_box_using_firebase/ui/auth/login.dart';
import 'package:chat_box_using_firebase/ui/chat_room.dart';
import 'package:chat_box_using_firebase/ui_logics/methods.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic>? userMap;

  bool isLoad = false;

  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController searchController = TextEditingController();

  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2[0].toLowerCase().codeUnits[0]) {
      return '$user1$user2';
    } else {
      return '$user2$user1';
    }
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoad = true;
    });
    await firestore
        .collection('users')
        .where('email', isEqualTo: searchController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoad = false;
      });
      print(userMap);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
        actions: [
          const SizedBox(
            width: 20,
          ),
          IconButton(
              onPressed: () async {
                await logout();
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
              icon: const Icon(Icons.logout_rounded))
        ],
      ),
      body: isLoad
          ? Center(
              child: SizedBox(
                height: size.height / 20,
                width: size.width / 20,
                child: const CircularProgressIndicator(),
              ),
            )
          : Column(
              children: [
                SizedBox(
                  height: size.height / 20,
                ),
                Container(
                  height: size.height / 14,
                  width: size.width,
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: size.height / 14,
                    width: size.width / 1.2,
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                          hintText: 'Search',
                          prefixIcon: const Icon(Icons.search_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height / 50,
                ),
                ElevatedButton(
                    onPressed: () {
                      onSearch();
                    },
                    child: const Text('Search')),
                userMap != null
                    ? ListTile(
                        onTap: () {
                          String roomId = chatRoomId(
                              auth.currentUser!.displayName.toString(),
                              userMap!['name']);
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatRoom(
                                        chatRoomId: roomId,
                                        userMap: userMap!,
                                      )));
                        },
                        leading: const Icon(
                          Icons.account_box_rounded,
                          color: Colors.black,
                        ),
                        title: Text(userMap!['name']),
                        subtitle: Text(userMap!['email'].toString()),
                        trailing: const Icon(
                          Icons.chat_rounded,
                          color: Colors.black,
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}
