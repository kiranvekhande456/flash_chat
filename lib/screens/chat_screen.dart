import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

late var currentUser;
bool isCurrentUser = true;

class ChatScreen extends StatefulWidget {
  static String id = "chat";

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  var _auth = FirebaseAuth.instance;
  var _store = FirebaseFirestore.instance;

  String message = "";
  var sender, text;
  TextEditingController messageTextField = TextEditingController();

  @override
  void initState() {
    getCurrentUser();

    super.initState();
  }

  void getCurrentUser() {
    currentUser = _auth.currentUser;
    print(currentUser);
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
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              MessageStream(store: _store),
              Container(
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: messageTextField,
                        onChanged: (value) {
                          message = value;
                        },
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    FlatButton(
                      onPressed: () async {
                        // currentUser.email + message
                        if (message != "") {
                          messageTextField.value = TextEditingValue.empty;
                          await _store.collection("messages").add({
                            "text": message,
                            "sender": currentUser.email,
                            "timestamp": DateTime.now()
                          });
                        }
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
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({
    Key? key,
    required FirebaseFirestore store,
  })  : _store = store,
        super(key: key);

  final FirebaseFirestore _store;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _store.collection('messages').orderBy("timestamp").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final docs = snapshot.data!.docs.reversed;
            List<MessageBubble> widgetList = [];
            for (QueryDocumentSnapshot document in docs) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              MessageBubble message = MessageBubble(
                  sender: data["sender"],
                  text: data["text"],
                  isCurrentUser: data["sender"] == currentUser.email);

              widgetList.add(message);
            }
            return Expanded(
              child: ListView(
                reverse: true,
                children: widgetList,
              ),
            );
          }

          return Center(child: Text("No data found"));
        });
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble(
      {required this.sender, required this.text, required this.isCurrentUser});

  final String sender;
  final String text;
  final bool isCurrentUser;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            "$sender",
            style: TextStyle(color: Colors.grey),
          ),
          Material(
            elevation: 10.0,
            shadowColor: Colors.black,
            borderRadius: isCurrentUser
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20))
                : BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
            color: isCurrentUser ? Colors.lightBlueAccent : Colors.blueGrey,
            child: Padding(padding: EdgeInsets.all(10), child: Text("$text")),
            textStyle: isCurrentUser
                ? TextStyle(fontSize: 20)
                : TextStyle(color: Colors.white, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
