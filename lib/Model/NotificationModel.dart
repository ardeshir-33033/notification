class NotificationMessages{

  String message;
  int importance;
  int id;

  NotificationMessages({this.importance , this.message , this.id});
}
List<NotificationMessages> NotifList = [
  NotificationMessages(importance: 1 , message:'Notif Lorem ipsum dolor sit amet, consectetur ', id: 1),
  NotificationMessages(importance: 3 , message:'Lorem ipsum dolor sit amet, consectetur adipiscing ' , id: 2),
  NotificationMessages(importance: 2 , message: 'Notif Lorem ipsum dolor sit amet, consectetur adipi ' , id: 3)
];