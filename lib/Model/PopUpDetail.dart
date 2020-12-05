class PopUpDetail{
  String detail;
  int importance;
  int id;

  PopUpDetail({
    this.detail,
    this.importance,
    this.id
  });
}
List<PopUpDetail> PopUpDetailList = [
  PopUpDetail(importance: 1 , detail: "paying the bills" , id: 1),
  PopUpDetail(importance: 3 , detail: "Lorem ipsum saz " , id: 2),
  PopUpDetail(importance: 2 , detail: "No Text ready now", id:3),
  PopUpDetail(importance: 2 , detail: "No Text not ready yet", id:4),
];