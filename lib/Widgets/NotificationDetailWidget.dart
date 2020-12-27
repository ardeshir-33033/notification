import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notification_page/Model/NotificationDetailModel.dart';

import '../Model/NotificationDetailModel.dart';
import '../Model/NotificationDetailModel.dart';
import '../Model/UserMessageModel.dart';
import '../Provider/SignalRProvider.dart';
import '../Provider/SignalRProvider.dart';

class NotificationDetailBuilder extends StatefulWidget {
  NotificationDetailBuilder({
    @required this.phoneWidth,
    @required this.NotifDetaliList,
    @required this.phoneHeight,
    this.visible,
    this.onNotifDeleteCallBack,
  });

  final double phoneWidth;
  final double phoneHeight;
  List<UserMessageModel> NotifDetaliList;
  bool visible;
  Function(List<UserMessageModel> NotifListCallBack) onNotifDeleteCallBack;

  @override
  _NotificationDetailBuilderState createState() =>
      _NotificationDetailBuilderState();
}

class _NotificationDetailBuilderState extends State<NotificationDetailBuilder> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Container(
        height: widget.phoneHeight / 1.6,
        width: widget.phoneWidth,
        child: ListView.builder(
          itemCount: widget.NotifDetaliList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  SignalRProvider()
                      .deleteMessage(widget.NotifDetaliList[index]);
                  widget.NotifDetaliList.removeAt(index);
                  widget.onNotifDeleteCallBack(widget.NotifDetaliList);
                });
              },
              child: Padding(
                padding: EdgeInsets.only(
                    left: widget.phoneWidth / 10,
                    right: widget.phoneWidth / 10,
                    bottom: 10),
                child: Container(
                  height: widget.phoneWidth / 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      width: 1,
                      color: Colors.red,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 10),
                        width: widget.phoneWidth / 1.8,
                        child: Text(
                          widget.NotifDetaliList[index].message,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 10.0),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            widget.NotifDetaliList[index].icon != null
                                ? NotifIcon(widget.NotifDetaliList[index].icon)
                                : 'assets/images/Rectangle.svg',
                            width: widget.phoneWidth / 7,
                          ),
                          Text(widget.NotifDetaliList[index].title)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

String NotifIcon(String IconString) {
  IconString.toLowerCase();
  if (IconString == 'it') {
    return 'assets/images/Circle.svg';
  }

  if (IconString == 'square') {
    return 'assets/images/Square.svg';
  }

  if (IconString == 'rectangle') {
    return 'assets/images/Rectangle.svg';
  }
  if (IconString == 'star') {
    return 'assets/images/Star.svg';
  }
}
