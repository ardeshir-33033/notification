

class PopUpMessages{

  String message;
  int importance;

  PopUpMessages({
    this.message,
    this.importance,
});
}
List<PopUpMessages> PopList = [
  PopUpMessages(importance: 1 , message:'PopUp Lorem ipsum dolor sit amet, consectetur '),
  PopUpMessages(importance: 3 , message:'PopUp Lorem ipsum sit amet, consectetur  elit, r '),
  PopUpMessages(importance: 2 , message: 'PopUp Lorem ipsum dolor sit amet, consectetur    '),
  PopUpMessages(importance: 2 , message: 'PopUp Lorem  dolor sit amet, consectetur  '),
  PopUpMessages(importance: 2 , message: 'PopUp Lorem ipsum dolor sit amet, consectetur  '),
];
