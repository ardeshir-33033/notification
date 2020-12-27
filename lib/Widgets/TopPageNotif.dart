import 'package:flutter/material.dart';
import 'package:notification_page/Model/NotificationModel.dart';
import 'package:notification_page/Model/PopUpModel.dart';

import '../Model/PopUpModel.dart';
import '../Model/UserMessageModel.dart';
import '../Provider/SignalRProvider.dart';

class TopNotifRow extends StatefulWidget {
  TopNotifRow({
    @required this.phoneHeight,
    @required this.phoneWidth,
    @required this.stableText,
    this.notifList,
    this.popUpList,
    this.visible,
    this.onTopNotifCallback,
  });

  String stableText;
  List<UserMessageModel> notifList;
  List<PopUpMessages> popUpList;
  final int visible;
  final double phoneHeight;
  final double phoneWidth;
  Function(List<UserMessageModel> NotifListCall) onTopNotifCallback;

  @override
  _TopNotifRowState createState() => _TopNotifRowState();
}

class _TopNotifRowState extends State<TopNotifRow> {
  List rawList;

  @override
  Widget build(BuildContext context) {
    if (widget.notifList == null) {
      rawList = widget.popUpList;
    } else {
      rawList = widget.notifList;
    }
    return Row(
      children: [
        Visibility(
          visible: widget.visible == 1 ? true : false,
          child: Padding(
            padding: EdgeInsets.only(left: 7.0),
            child: Text(
              '${rawList.length}${widget.stableText}',
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.only(left: 5),
          height: widget.phoneHeight / 7,
          width: widget.phoneWidth / 3.6,
          child: ListView.builder(
            itemCount: rawList.length,
            itemBuilder: (context, index) {
              return Dismissible(
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Color(0xFFDD3737),
                ),
                key: UniqueKey(),
                onDismissed: (direction) {
                  setState(() {
                    SignalRProvider().deleteMessage(widget.notifList[index]);
                    rawList.removeAt(index);
                    widget.notifList.removeAt(index);
                    widget.onTopNotifCallback(widget.notifList);
                  });
                },
                child: Column(
                  children: [
                    Container(
                      height: widget.phoneHeight / 7,
                      child: Center(
                        child: Text(
                          rawList[index].message,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        Visibility(
          visible: widget.visible == 2 ? true : false,
          child: Padding(
            padding: EdgeInsets.only(right: 4.0),
            child: Text(
              '${rawList.length}${widget.stableText}',
              style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
