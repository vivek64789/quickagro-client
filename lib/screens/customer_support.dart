import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/providers/chat_provider.dart';
import 'package:quickagro/providers/theme_provider.dart';
import 'package:quickagro/screens/customer_support_call.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:quickagro/utils/size.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickagro/widgets/chat_bubble.dart';
import 'package:quickagro/widgets/chat_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_client/socket_io_client.dart';

String _messageText = "";
TextEditingController _textController = new TextEditingController();

bool _sendingChat = false;
bool _loading = false;

class CustomerSupport extends StatefulWidget {
  @override
  _CustomerSupportState createState() => _CustomerSupportState();
}

class _CustomerSupportState extends State<CustomerSupport> {
  Socket? socket;

  @override
  void initState() {
    getChatMessages();
    super.initState();
    connectToWebSocket();
  }

  @override
  void dispose() {
    socket?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var textColor = Provider.of<ThemeProvider>(context).textColor;
    var chatProvider = Provider.of<ChatProvider>(context);

    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(width * 0.02),
        height: height,
        width: width,
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () {
                      Get.back();
                    },
                    icon: Icon(
                      FeatherIcons.chevronLeft,
                      color: textColor,
                    ),
                    tooltip: "Back",
                  ),
                  Column(
                    children: [
                      Text(
                        "Customer Support",
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: textColor,
                        ),
                      ),
                      Text(
                        "Ask any questions. Online 24/7",
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: textColor.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {
                      Get.to(() => CustomerSupportCall());
                    },
                    icon: Icon(
                      FeatherIcons.phoneCall,
                      color: primaryColor,
                    ),
                    tooltip: "Call",
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Expanded(
                child: _loading
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        reverse: true,
                        physics: BouncingScrollPhysics(),
                        itemCount: chatProvider.chatMessages.length,
                        itemBuilder: (context, index) {
                          return chatProvider.chatMessages[index]["isImage"]
                              ? ChatImage(
                                  imageURL: chatProvider.chatMessages[index]
                                      ["message"],
                                  isSender: !chatProvider.chatMessages[index]
                                      ["senderIsAdmin"],
                                )
                              : ChatBubble(
                                  message: chatProvider.chatMessages[index]
                                      ["message"],
                                  isSender: !chatProvider.chatMessages[index]
                                      ["senderIsAdmin"],
                                );
                        },
                      ),
              ),
              _sendingChat
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                  : SizedBox.shrink(),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      sendImage();
                    },
                    icon: Icon(
                      FeatherIcons.image,
                      color: textColor.withOpacity(0.5),
                    ),
                    tooltip: "Send Image",
                  ),
                  Expanded(
                    child: TextFormField(
                      textInputAction: TextInputAction.search,
                      controller: _textController,
                      onFieldSubmitted: (x) {
                        sendMessage();
                      },
                      onChanged: (text) {
                        _messageText = text;
                      },
                      autofocus: false,
                      decoration: InputDecoration(
                        hintText: "Type something here ...",
                        hintStyle: TextStyle(color: textColor.withOpacity(0.5)),
                        fillColor: textColor.withOpacity(0.1),
                        filled: true,
                      ),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: textColor,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      sendMessage();
                    },
                    icon: Icon(
                      FeatherIcons.send,
                      color: primaryColor,
                    ),
                    tooltip: "Send",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void sendImage() async {
    setState(() {
      _sendingChat = true;
    });
    Firebase.initializeApp();
    File imageFile;
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) {
      setState(() {
        _sendingChat = false;
      });
      return;
    }

    imageFile = File(pickedFile.path);

    var authProvider = Provider.of<AuthProvider>(Get.context!, listen: false);
    String fileName =
        authProvider.email + "_image_chat_" + DateTime.now().toIso8601String();
    var uploadTask = await FirebaseStorage.instance
        .ref()
        .child("uploads/$fileName")
        .putFile(imageFile);
    uploadTask.ref.getDownloadURL().then((value) {
      _messageText = value;

      Map newMsg = {
        "chatId": Provider.of<ChatProvider>(context, listen: false).chatId,
        "message": _messageText,
        "senderIsAdmin": false,
        "isImage": true,
      };
      socket?.emit("message", newMsg);
      _textController.clear();
      _messageText = "";
      setState(() {
        _sendingChat = false;
      });
    });
  }

  void sendMessage() {
    if (_messageText == "") return;
    Map newMsg = {
      "chatId": Provider.of<ChatProvider>(context, listen: false).chatId,
      "message": _messageText,
      "senderIsAdmin": false,
      "isImage": false,
    };
    socket?.emit("message", newMsg);
    _textController.clear();
    _messageText = "";
  }

  void connectToWebSocket() {
    try {
      socket = io(serverUrl, <String, dynamic>{
        'transports': ['websocket'],
        'autoConnect': false,
      });

      socket?.connect();

      socket?.on("message", (message) {
        if (message["chatId"] ==
            Provider.of<ChatProvider>(context, listen: false).chatId) {
          Provider.of<ChatProvider>(context, listen: false)
              .addChatMessage(message);
        }
      });
    } catch (e) {}
  }

  getChatMessages() async {
    setState(() {
      _loading = true;
    });
    await Provider.of<ChatProvider>(context, listen: false).getChatMessages();
    setState(() {
      _loading = false;
    });
  }
}
