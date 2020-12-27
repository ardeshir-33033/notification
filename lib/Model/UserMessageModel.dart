class UserMessageModel{
  int Id;
bool deleted;
bool isActive;
String creationDateTime;
int creationDay;
String creationPersianDateTime;
String modifiedDateTime;
int modifiedDay;
String modifiedPersianDateTime;
String deletedDateTime;
int deletedDay;
String deletedPersianDateTime;
int priority;
int important;
String status;
int userCreatedId;
String systemTag;
String systemCategory;
int identity;
String category;
String user;
String sender;
String app;
String title;
String message;
String icon;
String image;
String link;
String jsonData;
String sentTime;
String recivedTime;
String seenTime;
  

  UserMessageModel({
    this.seenTime = "",
    this.recivedTime = "",
    this.sentTime = "",
    this.jsonData,
    this.link = "",
    this.image = "",
    this.icon = "",
    this.message = "",
    this.title = "",
    this.app = "",
    this.user,
    this.identity,
    this.category,
    this.creationDay,
    this.creationPersianDateTime,
    this.creationDateTime,
    this.deleted,
    this.deletedDay,
    this.deletedPersianDateTime,
    this.deletedDateTime,
    this.Id,
    this.important,
    this.isActive,
    this.modifiedDay,
    this.modifiedPersianDateTime,
    this.modifiedDateTime,
    this.priority,
    this.sender,
    this.status,
    this.systemCategory,
    this.systemTag,
    this.userCreatedId,
});

  UserMessageModel.fromJson(Map<String, dynamic> json) {
    seenTime = json["seenTime"];
    recivedTime = json["recivedTime"];
    sentTime = json["sentTime"];
    jsonData = json["jsonData"];
    link = json["link"];
    image = json["image"];
    icon = json["icon"];
    message = json["message"];
    title = json["title"];
    app  = json["app"];
    user = json["user"];
    identity = json["identity"];
    category = json["category"];
    creationDay = json["creationDay"];
    creationPersianDateTime = json["creationPersianDateTime"];
    creationDateTime = json["creationDateTime"];
    deleted = json["deleted"];
    deletedDay = json["deletedDay"];
    deletedPersianDateTime = json["deletedPersianDateTime"];
    deletedDateTime = json["deletedDateTime"];
    Id = json["Id"];
    important = json["important"];
    isActive = json["isActive"];
    modifiedDay = json["modifiedDay"];
    modifiedPersianDateTime = json["modifiedPersianDateTime"];
    modifiedDateTime = json["modifiedDateTime"];
    priority = json["priority"];
    sender = json["sender"];
    status = json["status"];
    systemCategory = json["systemCategory"];
    systemTag = json["systemTag"];
    userCreatedId = json["userCreatedId"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.isActive != null) data['isActive'] = this.isActive;
    if(this.deleted != null) data['deleted'] = this.deleted;
    if(this.jsonData != null) data['jsonData'] = this.jsonData;
    if(this.userCreatedId != null) data['userCreatedId'] = this.userCreatedId;
    if(this.user != null) data['user'] = this.user;
    if(this.systemTag != null) data['systemTag'] = this.systemTag;
    if(this.systemCategory != null) data['systemCategory'] = this.systemCategory;
    if(this.status != null) data['status'] = this.status;
    if(this.sender != null) data['sender'] = this.sender;
    if(this.priority != null) data['priority'] = this.priority;
    if(this.important != null) data['important'] = this.important;
    if(this.modifiedDateTime != null) data['modifiedDateTime'] = this.modifiedDateTime;
    if(this.modifiedPersianDateTime != null) data['modifiedPersianDateTime'] = this.modifiedPersianDateTime;
    if(this.modifiedDay != null) data['modifiedDay'] = this.modifiedDay;
    if(this.Id != null) data['Id'] = this.Id;
    if(this.deletedDay != null) data['deletedDay'] = this.deletedDay;
    if(this.category != null) data['category'] = this.category;
    if(this.app != null) data['app'] = this.app;
    if(this.message  != null) data['message'] = this.message;
    if(this.title != null) data['title'] = this.title;
    if(this.icon != null) data['icon'] = this.icon;
    if(this.image != null) data['image'] = this.image;
    if(this.deletedPersianDateTime != null) data['deletedPersianDateTime'] = this.deletedPersianDateTime;
    if(this.recivedTime != null) data['recivedTime'] = this.recivedTime;
    if(this.seenTime != null) data['seenTime'] = this.seenTime;
    if(this.sentTime != null) data['sentTime'] = this.sentTime;
    if(this.link != null) data['link'] = this.link;
    if(this.identity != null) data['identity'] = this.identity;
    if(this.creationDay != null) data['creationDay'] = this.creationDay;
    if(this.creationPersianDateTime != null) data['creationPersianDateTime'] = this.creationPersianDateTime;
    if(this.creationDateTime != null) data['creationDateTime'] = this.creationDateTime;
    if(this.deletedDateTime != null) data['deletedDateTime'] = this.deletedDateTime;
    return data;
  }

  List<UserMessageModel> listFromJson(dynamic jsns) {
    if (jsns != null) {
      return jsns.map<UserMessageModel>((ct) {
        return UserMessageModel.fromJson(ct);
      }).toList();
    }

    return null;
  }
}