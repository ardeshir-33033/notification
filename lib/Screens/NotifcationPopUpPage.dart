import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:notification_page/Model/NotificationDetailModel.dart';
import 'package:notification_page/Model/NotificationModel.dart';
import 'package:notification_page/Model/PopUpDetail.dart';
import 'package:notification_page/Model/PopUpModel.dart';
import 'package:notification_page/Model/UserMessageModel.dart';
import 'package:notification_page/Provider/SPProvider.dart';
import 'package:notification_page/Provider/SignalRProvider.dart';
import 'package:notification_page/Widgets/NotificationDetailWidget.dart';
import 'package:notification_page/Widgets/PopUpDetailWidget.dart';
import 'package:notification_page/Widgets/TopPageNotif.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signalr_core/signalr_core.dart';

import '../Model/UserMessageModel.dart';
import '../Provider/SignalRProvider.dart';

class NotificationsPage extends StatefulWidget {
  bool NotifPopVisible = false;
  bool popUpVisible = false;

  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  int counter = 0;
  List<UserMessageModel> messages = List<UserMessageModel>();
  List<UserMessageModel> notif = List<UserMessageModel>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SignalRProvider(onMessagesUpdateCallback: (result) {
      counter = SignalRProvider().getMessages().length;
      var msgs = SignalRProvider().getMessages();
      print('messages:$msgs');

      messages = msgs.reversed.toList();
      notif = msgs;

      setState(() {});
    }).initSignalR();
  }

  @override
  Widget build(BuildContext context) {
    double phoneWidth = MediaQuery.of(context).size.width;
    double phoneHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Dismissible(
              direction: DismissDirection.startToEnd,
              key: UniqueKey(),
              child: Padding(
                padding: EdgeInsets.only(
                  top: phoneHeight / 20,
                  left: phoneWidth / 11,
                  right: phoneWidth / 11,
                ),
                child: Container(
                  height: phoneHeight / 7,
                  decoration: BoxDecoration(
                    color: Color(0xFFDD3737),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        child: TopNotifRow(
                          visible: 1,
                          phoneHeight: phoneHeight,
                          phoneWidth: phoneWidth,
                          popUpList: PopList,
                          stableText: 'P',
                        ),
                        onTap: () {
                          setState(() {
                            if (widget.NotifPopVisible == true) {
                              widget.NotifPopVisible = false;
                            }
                            widget.popUpVisible = true;
                          });
                        },
                      ),
                      GestureDetector(
                        child: TopNotifRow(
                          visible: 2,
                          phoneHeight: phoneHeight,
                          phoneWidth: phoneWidth,
                          notifList: messages,
                          stableText: 'N',
                          onTopNotifCallback:
                              (List<UserMessageModel> notifList) {
                            messages = notifList;
                            setState(() {});
                          },
                        ),
                        onTap: () {
                          setState(() {
                            if (widget.popUpVisible == true) {
                              widget.popUpVisible = false;
                            }
                            widget.NotifPopVisible = true;
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.width / 12,
            ),
            // Visibility(visible:(PopUpDetailList == null &&  NotifDetailList == null),
            //     child: Text('You have no Notifications left')),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                PopUpDetailBuilder(
                  phoneHeight: phoneHeight,
                  phoneWidth: phoneWidth,
                  popUpDetailList: PopUpDetailList,
                  visible: widget.popUpVisible,
                ),
                NotificationDetailBuilder(
                  phoneWidth: phoneWidth,
                  phoneHeight: phoneHeight,
                  NotifDetaliList: messages,
                  visible: widget.NotifPopVisible,
                  onNotifDeleteCallBack:
                      (List<UserMessageModel> NotifDetaliList) {
                    messages = NotifDetaliList;
                    setState(() {});
                  },
                ),
              ],
            ),
            // RaisedButton(
            //   onPressed: ()async {
            //     await SignalRProvider().fetchMessages();
            //     setState(() {});
            //   },
            //   color: Colors.red,
            // )
          ],
        ),
      ),
    );
  }
}
