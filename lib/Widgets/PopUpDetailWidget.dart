import 'package:flutter/material.dart';
import 'package:notification_page/Model/NotificationDetailModel.dart';
import 'package:notification_page/Model/PopUpDetail.dart';


class PopUpDetailBuilder extends StatefulWidget {
  PopUpDetailBuilder({
    @required this.phoneHeight,
    @required this.phoneWidth,
    @required this.popUpDetailList,
    this.visible,
  });

  List<PopUpDetail> popUpDetailList;
  final bool visible;
  final double phoneHeight;
  final double phoneWidth;

  @override
  _PopUpDetailBuilderState createState() =>
      _PopUpDetailBuilderState();
}

class _PopUpDetailBuilderState
    extends State<PopUpDetailBuilder> {
  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: widget.visible,
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: widget.phoneWidth / 11,
            ),
            height: widget.phoneHeight / 1.6,
            width: widget.phoneWidth / 3,
            child: ListView.builder(
              itemCount: PopUpDetailList.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.white,
                  ),
                  key: UniqueKey(),
                  onDismissed: (direction) {
                    setState(() {
                      PopUpDetailList.removeAt(index);
                    });
                  },
                  child: Card(
                    color: Color(0xFFDD3737),
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: widget.phoneHeight / 17,
                          horizontal: widget.phoneWidth / 40,
                        ),
                        child: Text(
                          PopUpDetailList[index].detail,
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
