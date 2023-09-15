import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _firestore = FirebaseFirestore.instance;
// User? loggedInUser;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  // final _firestore = Firestore.instance;
  // final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  // late User loggedInUser;

  late String messageText;

  // final _firestore = Firestore.instance;

  final messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;

      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getMessages() async {
  //   final messages = await _firestore.collection('messages').get();
  //   for (var message in messages.docs) {
  //     // print(message.data());
  //     Map<String, dynamic> data = message.data();
  //     print(data['sender']);
  //     print(data['text']);
  //   }
  // }

  void messageStream() async {
    await for (var snapshot
        in _firestore.collection('messages').orderBy('timestamp').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              //Implement logout functionality
              _auth.signOut();
              Navigator.pop(context);
              // getMessages();
              // messageStream();
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MessageStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value) {
                        //Do something with the user input.
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      messageController.clear();
                      _firestore
                          .collection('messages')
                          .doc(DateTime.now().toString())
                          .set({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                      // it takes long time when we click on log in or register button
                      // to move to the chat_screeen
                      // please be patient

                      // it also takes time when we click on 'Send' button
                      // to upload this data to the firebase database
                      // please be patient
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data?.docs.reversed;
        List<MessageBubble> messageWidgets = [];
        for (var message in messages!) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = loggedInUser.email;

          // if (currentUser == messageSender) {
          // do something about the text widgets
          // more simpler way is you could assign a boolean property to the class MessageBubble
          // that whether the user is me or not
          // }

          final messageWidget = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageWidgets.add(messageWidget);
        }
        return Expanded(
          // we needed to wrap listview around expanded widget cause listview takes infinite space
          // when left as it is
          // by wrapping around expanded widget, it will also consider the space required for other
          // widgets on the screen (here, the input text widget and the elevated button -> the send one wala)
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageWidgets,
          ),
        );
      },
      // return Text("No widget to build"); // finally done with this shit
      // now just need to decorate it a bit
      stream: _firestore.collection('messages').snapshots(),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});

  late String text;
  late String sender;
  late bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        // crossAxisAlignment: CrossAxisAlignment.end,
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
              // borderRadius: BorderRadius.circular(30.0),
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(30.0),
              //   bottomLeft: Radius.circular(30.0),
              //   bottomRight: Radius.circular(30.0),
              // ),
              borderRadius: isMe
                  ? BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    )
                  : BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      bottomRight: Radius.circular(30.0),
                      bottomLeft: Radius.circular(30.0),
                    ),
              elevation: 5.0,
              // color: Colors.lightBlueAccent,
              color: isMe ? Colors.lightBlueAccent : Colors.white,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  text,
                  style: TextStyle(
                    // color: Colors.white,
                    color: isMe ? Colors.white : Colors.black54,
                    fontSize: 15.0,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}

// One way of writing :
// StreamBuilder Code
// StreamBuilder<QuerySnapshot>(
// builder: (context, snapshot) {
// try {
// if (snapshot.hasData) {
// final messages = snapshot.data?.docs;
// List<Text> messageWidgets = [];
// for (var message in messages!) {
// final messageText = message['text'];
// final messageSender = message['sender'];
//
// final messageWidget = Text(
// '$messageText from $messageSender',
// );
//
// messageWidgets.add(messageWidget);
// }
// return Column(
// children: messageWidgets,
// );
// }
// } catch (e) {
// print(e);
// rethrow;
// }
// return Text("No widget to build");
// },
// finally done with this shit
// now just need to decorate it a bit

// Other way of writing Streambuilder code
// StreamBuilder<QuerySnapshot>(
// builder: (context, snapshot) {
// if (!snapshot.hasData) {
// return Center(
// child: CircularProgressIndicator(
// backgroundColor: Colors.lightBlueAccent,
// ),
// );
// }
// final messages = snapshot.data?.docs;
// List<Text> messageWidgets = [];
// for (var message in messages!) {
// final messageText = message['text'];
// final messageSender = message['sender'];
//
// final messageWidget = Text(
// '$messageText from $messageSender',
// );
//
// messageWidgets.add(messageWidget);
// }
// return Column(
// children: messageWidgets,
// );
// },
