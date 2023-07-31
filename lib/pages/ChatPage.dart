
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messanger_app/components/chat_bubble.dart';
import 'package:messanger_app/components/my_text_field.dart';
import 'package:messanger_app/services/chat/ChatService.dart';

class ChatPage extends StatefulWidget {
  final String receivedUserEmail;
  final String receivedUserID;
  const ChatPage(
      {super.key,
      required this.receivedUserEmail,
      required this.receivedUserID});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ChatService _chatService = ChatService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      //only send message if there is something to send
      await _chatService.sendMessage(
          widget.receivedUserID, _messageController.text);
      //clear the text controller after sending the message
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.receivedUserEmail)),
      body: Column(children: [
        //message
        Expanded(
          child: _buildMessageList(),
        ),

        //user input
        _buildMessageInput(),

        SizedBox(height: 25,)
      ]),
    );
  }

  // build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatService.getMessages(
          widget.receivedUserID, _firebaseAuth.currentUser!.uid),
      builder: (context, snapshot) {

        if (snapshot.hasError) {
          return Text('Error${snapshot.error}');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('Loading...');
        }

        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    // align the message to the right if the sender is the current user, otherwise to the left
    var alignment = (data['senderId'] == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,

           mainAxisAlignment: (data['senderId'] == _firebaseAuth.currentUser!.uid)
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
          children: [
          Text(data['senderEmail']),
          SizedBox(height: 4,),
          ChatBubble(message: data['message']),
        ]),
      ),
    );
  }

  //build message input
  Widget _buildMessageInput() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          //textField
          Expanded(
              child: MyTextField(
            controller: _messageController,
            hintText: 'Enter Message',
            obscureText: false,
          )),
    
          //Send button
          IconButton(
              onPressed: sendMessage,
              icon: Icon(
                Icons.send,
                size: 40,
              )
          )
        ],
      ),
    );
  }
}
