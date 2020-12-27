import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:notification_page/Model/UserMessageModel.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRProvider with ChangeNotifier{
  static String appName = "NotifApp";
  static List<UserMessageModel> messages = List<UserMessageModel>();

  static HubConnection connection = HubConnectionBuilder().withUrl('https://signal.dinavision.org/chatHub',
  HttpConnectionOptions(
  logging: (level, message) => print(message),
  )).build();

  Function(bool update) onMessagesUpdateCallback;

  SignalRProvider({
    this.onMessagesUpdateCallback,
});

  Future initSignalR() async {
    await connection.start();

      connection.on('ReceiveMessage', (message) async {
        UserMessageModel msg = UserMessageModel.fromJson(message.first);
        messages.add(msg);

        if(msg.user == "mojarab"){
          await connection.invoke('SendRecivedMessage', args: [msg.app, msg.user, msg.identity]);
        }

        if(onMessagesUpdateCallback != null){
          onMessagesUpdateCallback(true);
        }
      });


    connection.on('ReceiveUpdatedMessage', (message) async {

      UserMessageModel msg = UserMessageModel.fromJson(message.first);
      addOrUpdateMessage(msg);
    });

    connection.on('UserMessages', (message) async {

      var jsonArray = jsonDecode(message.first);
      List<UserMessageModel> msgs = UserMessageModel().listFromJson(jsonArray);
      messages = msgs;

      if(onMessagesUpdateCallback != null){
        onMessagesUpdateCallback(true);
      }
    });

    connection.on("ReceiveConnectedMessage", (message) async {
      await connection.invoke('Init', args: [appName, 'mojarab', connection.connectionId, 'notification_app']);

      fetchMessages(); 
    });

    connection.on("ReceiveDisconnectedMessage", (message) async {
      await connection.start();
    });

    Timer timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      if(connection.state == HubConnectionState.connected){
        await connection.invoke('StayLiveMessage', args: [appName, 'mojarab', 'i am alive']);
      }else{
        await connection.start();
      }
    });
  }

  Future fetchMessages() async {
    await connection.invoke('GetMyMessages', args: [appName, 'mojarab']);

    if(onMessagesUpdateCallback != null){
      onMessagesUpdateCallback(true);
    }
  }

  List<UserMessageModel> getMessages(){
    return messages;
  }

  Future seenMessage(UserMessageModel _msg) async {
    await connection.invoke('SendSeenMessage', args: [_msg.app, _msg.user, _msg.identity]);
    messages = messages.where((e) => e.app != _msg.app && e.user != _msg.user && e.identity != _msg.identity).toList();

    if(onMessagesUpdateCallback != null){
      onMessagesUpdateCallback(true);
    }
  }

  Future deleteMessage(UserMessageModel _msg) async {
    await connection.invoke('SendRemoveMessage', args: [_msg.app, _msg.user, _msg.identity]);
    messages = messages.where((e) => e.app != _msg.app && e.user != _msg.user && e.identity != _msg.identity).toList();

    if(onMessagesUpdateCallback != null){
      onMessagesUpdateCallback(true);
    }
  }

  addOrUpdateMessage(UserMessageModel _msg){
    if(messages != null){
      var found = messages.firstWhere((e) => e.app == _msg.app && e.user == _msg.user && e.identity == _msg.identity);
      var index = messages.indexWhere((e) => e.app == _msg.app && e.user == _msg.user && e.identity == _msg.identity);

      if(found != null){
        messages[index] = _msg;
      }else{
        messages.add(_msg);
      }

      if(onMessagesUpdateCallback != null){
        onMessagesUpdateCallback(true);
      }
    }
  }

  setMessagesUpdateCallback(Function(bool update) func){
    onMessagesUpdateCallback = func;
  }
}