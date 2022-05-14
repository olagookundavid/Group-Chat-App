import 'package:chat_app/services/crud/firestorecrud.dart';
import 'package:chat_app/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/utilities/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utilities/dialogues.dart';
import 'login_screen.dart';

CrudMethods crudMethod = CrudMethods();
enum MenuAction { logout, switchuser }

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late final TextEditingController _messageTextController;
  @override
  void initState() {
    super.initState();
    crudMethod.isLoggedIn();
    _messageTextController = TextEditingController();
  }

  @override
  void dispose() {
    _messageTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () async {
            final shouldDelete = await deleteAllMessagesDialog(context);
            if (shouldDelete) {
              crudMethod.deleteData();
            }
          },
        ),
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldlogout = await showLogoutDialog(context);

                  if (shouldlogout) {
                    crudMethod.logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, WelcomeScreen.id, (route) => false);
                  }
                  break;
                case MenuAction.switchuser:
                  final shouldswitchuser = await switchUserDialog(context);

                  if (shouldswitchuser) {
                    crudMethod.logOut();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.id, (route) => false);
                  }
                  break;
              }
            },
            itemBuilder: (BuildContext context) {
              return const [
                PopupMenuItem<MenuAction>(
                  child: Text('Log Out'),
                  value: MenuAction.logout,
                ),
                PopupMenuItem<MenuAction>(
                  child: Text('Switch User'),
                  value: MenuAction.switchuser,
                )
              ];
            },
          )
        ],
        title: const Text(
          'Team Chat',
          style: TextStyle(
            color: Colors.blueGrey,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: crudMethod.getMessageStreams(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messages = snapshot.data?.docs.reversed;
                List<MessageBubble> messageWidgets = [];
                for (var message in messages!) {
                  final String messagetext = message.data()['text'];
                  final String messageSender = message.data()['sender'];
                  final messagebubble = MessageBubble(
                    text: messagetext,
                    sender: messageSender,
                    isMe: loggedInUser == messageSender,
                  );

                  messageWidgets.add(messagebubble);
                }
                return Expanded(
                  child: ListView(
                    reverse: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 20,
                    ),
                    children: messageWidgets,
                  ),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.lightBlueAccent,
                  ),
                );
              }
            },
          ),
          Container(
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _messageTextController,
                    decoration: kMessageTextFieldDecoration,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    final messageText = _messageTextController.text;
                    _messageTextController.clear();
                    Map<String, dynamic> messageData = {
                      'text': messageText,
                      'sender': loggedInUser,
                      'timestamp': FieldValue.serverTimestamp(),
                    };
                    crudMethod.addData(messageData);
                  },
                  child: const Text(
                    'Send',
                    style: kSendButtonTextStyle,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({
    Key? key,
    required this.text,
    required this.sender,
    required this.isMe,
  }) : super(key: key);
  final String? text;
  final String? sender;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender!,
            style: const TextStyle(
              fontSize: 10,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  )
                : const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
            elevation: 5,
            color: isMe ? Colors.lightBlueAccent : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 20,
              ),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
