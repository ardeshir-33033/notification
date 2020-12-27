class NotificationDetail{
  String detail;
  int importance;
  int id;
  String SvgAdress;
  String title;

  NotificationDetail({
    this.detail,
    this.importance,
    this.id,
    this.SvgAdress,
    this.title,
});
}
// List<NotificationDetail> NotifDetailList = [
//   NotificationDetail(importance: 1 , detail: " لو نامفهوم از گرافیک است" , id: 1 , title: 'IT' , SvgAdress: 'assets/images/Circle.svg'),
//   NotificationDetail(importance: 3 , detail: " لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از گرافیک است" , id: 2 , title: 'Sales' , SvgAdress: 'assets/images/Square.svg'),
//   NotificationDetail(importance: 2 , detail: "لورم ایپسوم متن ساختگی با تولید  از گرافیک است", id:3 , title: 'Fix' , SvgAdress: 'assets/images/Rectangle.svg'),
//   NotificationDetail(importance: 2 , detail: "لورم ایپسوم متن ساختگی با تولید سادگی نامفهوم از گرافیک است", id:4 , title: 'IT' , SvgAdress: 'assets/images/Star.svg'),
// ];