import 'dart:async';
import 'dart:convert';
import 'package:notification_page/Model/QueryModel.dart';
import 'package:notification_page/Model/Response.dart';
import 'package:notification_page/Model/UserMessageModel.dart';
import 'package:notification_page/Provider/EndPointService.dart';
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
    try{
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

        if(msgs != null && msgs.length > 0){
          for(var item in msgs){
            if (item.user == userName) {
              await connection.invoke('SendRecivedMessage',
                  args: [item.app, item.user, item.identity]);
            }
            addOrUpdateMessage(item);
          }
        }

        if (onMessagesUpdateCallback != null) {
          onMessagesUpdateCallback(true);
        }
      });

      connection.on("ReceiveConnectedMessage", (message) async {
        await connection.invoke('Init', args: [
          appName,
          userName,
          connection.connectionId,
          deviceName
        ]);

        var response = await EndPointService().SetupApi("Message", "", [
          QueryModel( name: "user",value: userName),
        ]).httpGet(
            HeaderEnum.BasicHeaderEnum,
            ResponseEnum.ResponseModelEnum
        );

        if(response != null){
          messages = UserMessageModel().listFromJson(response);

          if (onMessagesUpdateCallback != null) {
            onMessagesUpdateCallback(true);
          }
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
          await connection.start();
        }
      });

      Timer timer1 = Timer.periodic(Duration(seconds: 10), (timer) async {
        var response = await EndPointService().SetupApi("Message", "", [
          QueryModel( name: "user",value: userName),
        ]).httpGet(
            HeaderEnum.BasicHeaderEnum,
            ResponseEnum.ResponseModelEnum
        );

        if(response != null){
          messages = UserMessageModel().listFromJson(response);

          if (onMessagesUpdateCallback != null) {
            onMessagesUpdateCallback(true);
          }
        }

        if (connection.state == HubConnectionState.connected) {
          await connection.invoke('SendUnsendedMessages', args: [appName, userName, deviceName]);
        } else {
          await connection.start();
        }
      });
    }catch(e){

    }
  }

  List<UserMessageModel> getMessages() {
    return messages;
  }

  Future seenMessage(UserMessageModel _msg) async {
    try{
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
    }catch(e){

    }
  }

  Future deleteMessage(UserMessageModel _msg) async {
    try{
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
    }catch(e){

    }
  }

  addOrUpdateMessage(UserMessageModel _msg) {
    try{
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
    }catch(e){

    }
  }

  setMessagesUpdateCallback(Function(bool update) func) {
    onMessagesUpdateCallback = func;
  }
}
