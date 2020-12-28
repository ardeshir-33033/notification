import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:notification_page/Model/UserMessageModel.dart';
import 'package:signalr_core/signalr_core.dart';

class SignalRProvider {
  static String appName = "MANAGOSTAR_NOTIFICATION";
  static String userName = "mojarab";
  static String deviceName = "android_app";

  static List<UserMessageModel> messages = List<UserMessageModel>();

  HubConnection connection = HubConnectionBuilder()
      .withUrl(
           'https://signal.dinavision.org/chatHub',
    //'https://localhost:44337/chathub',
          HttpConnectionOptions(
            logging: (level, message) => print(message),
          ))
      .build();

  Function(bool update) onMessagesUpdateCallback;

  SignalRProvider({
    this.onMessagesUpdateCallback,
  });

  Future initSignalR() async {
    await connection.start();

    connection.on('ReceiveMessage', (message) async {
      UserMessageModel msg = UserMessageModel.fromJson(message.first);
      messages.add(msg);

      if (msg.user == userName) {
        await connection.invoke('SendRecivedMessage',
            args: [msg.app, msg.user, msg.identity]);
      }

      if (onMessagesUpdateCallback != null) {
        onMessagesUpdateCallback(true);
      }
    });

    connection.on('ReceiveLiveMessage', (message) {
      try{
        print("user:${message.first} ..... message:${message.last}");
      }catch(e){
        print(e);
      }
    });

    connection.on('ReceiveUpdatedMessage', (message) async {
      UserMessageModel msg = UserMessageModel.fromJson(message.first);
      addOrUpdateMessage(msg);
    });

    connection.on('ReceiveUserMessages', (message) async {
      var jsonArray = jsonDecode(message.first);
      List<UserMessageModel> msgs = UserMessageModel().listFromJson(jsonArray);
      messages = msgs;

      if (onMessagesUpdateCallback != null) {
        onMessagesUpdateCallback(true);
      }
    });

    connection.on('ReceiveUnReceivedMessages', (message) async {
      var jsonArray = jsonDecode(message.first);
      List<UserMessageModel> msgs = UserMessageModel().listFromJson(jsonArray);
      messages.addAll(msgs);

      if (onMessagesUpdateCallback != null) {
        onMessagesUpdateCallback(true);
      }
    });

    connection.on("ReceiveConnectedMessage", (message) async {
      try {
        await connection.invoke('Init', args: [
          appName,
          userName,
          connection.connectionId,
          deviceName
        ]);
      } catch (e) {
        print(e);
      }
    });

    connection.on("ReceiveDisconnectedMessage", (message) async {
      await connection.start();
    });

    Timer timer = Timer.periodic(Duration(seconds: 20), (timer) async {
      if (connection.state == HubConnectionState.connected) {
        await connection.invoke('StayLiveMessage',
            args: [appName, userName, 'i am alive']);
      } else {
        //await connection.start();
      }
    });

    Timer timer1 = Timer.periodic(Duration(seconds: 15), (timer) async {
      if (connection.state == HubConnectionState.connected) {
        await connection.invoke('SendMyMessages', args: [appName, userName, deviceName]);
      } else {
        //await connection.start();
      }
    });

    Timer timer2 = Timer.periodic(Duration(seconds: 25), (timer) async {
      if (connection.state == HubConnectionState.connected) {
        await connection.invoke('SendUnsendedMessages', args: [appName, userName, deviceName]);
      } else {
        //await connection.start();
      }
    });
  }

  List<UserMessageModel> getMessages() {
    return messages;
  }

  Future seenMessage(UserMessageModel _msg) async {
    await connection
        .invoke('SendSeenMessage', args: [_msg.app, _msg.user, _msg.identity]);
    messages = messages
        .where((e) =>
            e.app != _msg.app &&
            e.user != _msg.user &&
            e.identity != _msg.identity)
        .toList();

    if (onMessagesUpdateCallback != null) {
      onMessagesUpdateCallback(true);
    }
  }

  Future deleteMessage(UserMessageModel _msg) async {
    await connection.invoke('SendRemoveMessage',
        args: [_msg.app, _msg.user, _msg.identity]);
    messages = messages
        .where((e) =>
            e.app != _msg.app &&
            e.user != _msg.user &&
            e.identity != _msg.identity)
        .toList();

    if (onMessagesUpdateCallback != null) {
      onMessagesUpdateCallback(true);
    }
  }

  addOrUpdateMessage(UserMessageModel _msg) {
    if (messages != null) {
      var found = messages.firstWhere((e) =>
          e.app == _msg.app &&
          e.user == _msg.user &&
          e.identity == _msg.identity);
      var index = messages.indexWhere((e) =>
          e.app == _msg.app &&
          e.user == _msg.user &&
          e.identity == _msg.identity);

      if (found != null) {
        messages[index] = _msg;
      } else {
        messages.add(_msg);
      }

      if (onMessagesUpdateCallback != null) {
        onMessagesUpdateCallback(true);
      }
    }
  }

  setMessagesUpdateCallback(Function(bool update) func) {
    onMessagesUpdateCallback = func;
  }
}
