import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notification_page/Model/NotificationDetailModel.dart';

class NotificationDetailBuilder extends StatefulWidget {
  NotificationDetailBuilder({
    @required this.phoneWidth,
    @required this.NotifDetaliList,
    @required this.phoneHeight,
    this.visible,
  });

  final double phoneWidth;
  final double phoneHeight;
  final List<NotificationDetail> NotifDetaliList;
  bool visible;

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
          itemCount: NotifDetailList.length,
          itemBuilder: (context, index) {
            return Dismissible(
              direction: DismissDirection.endToStart,
              key: UniqueKey(),
              onDismissed: (direction) {
                setState(() {
                  NotifDetailList.removeAt(index);
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
                          widget.NotifDetaliList[index].detail,
                          textDirection: TextDirection.rtl,
                          style: TextStyle(fontSize: 12.0),
                        ),
                      ),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            widget.NotifDetaliList[index].SvgAdress,
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