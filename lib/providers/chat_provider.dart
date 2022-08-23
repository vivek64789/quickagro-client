import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:quickagro/providers/auth_provider.dart';
import 'package:quickagro/utils/colors.dart';
import 'package:quickagro/utils/server.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ChatProvider extends ChangeNotifier {
  String chatId = "";
  List<dynamic> chatMessages = [];

  getChatId() async {
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {"Authorization": "JWT $token"};

    var response = await http.get(Uri.parse("$serverUrl/chats/get-chat-id"),
        headers: headers);

    chatId = jsonDecode(response.body);
    notifyListeners();
  }

  addChatMessage(Map newMessage) {
    chatMessages = chatMessages.reversed.toList();
    chatMessages.add(newMessage);
    chatMessages = chatMessages.reversed.toList();
    notifyListeners();
  }

  getChatMessages() async {
    await getChatId();
    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {"Authorization": "JWT $token"};

    var response = await http.get(Uri.parse("$serverUrl/chats/get-messages"),
        headers: headers);

    chatMessages = jsonDecode(response.body);
    notifyListeners();
  }

  sendMessage(String messageText) async {
    chatMessages = chatMessages.reversed.toList();
    chatMessages.add({
      "message": messageText,
      "senderIsAdmin": false,
      "date": DateTime.now().toIso8601String()
    });
    chatMessages = chatMessages.reversed.toList();

    String token = Provider.of<AuthProvider>(Get.context!, listen: false).token;

    Map<String, String> headers = {
      "Authorization": "JWT $token",
      "Content-type": "application/json"
    };

    Map<String, dynamic> body = {
      "chatId": chatId,
      "message": messageText,
    };

    var response = await http.post(
      Uri.parse("$serverUrl/chats/new-message"),
      headers: headers,
      body: jsonEncode(body),
    );

    if (response.statusCode != 200) {
      Fluttertoast.showToast(
        msg: "Couldn't send message.\nPlease try again",
        backgroundColor: primaryColor,
      );
    }

    notifyListeners();
  }
}
