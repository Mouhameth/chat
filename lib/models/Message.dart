class Message{
  String message;
  bool isMe;
  String emetteur;
  String isImage;
  String id;
  String vu;
  Message(this.message,this.isImage,this.isMe,this.id,this.vu);
  Message.fromJson(dynamic obj){
    this.emetteur= obj["emetteur"];
    this.isImage = obj["isImage"];
    this.message = obj["message"];
    this.id = obj["id"];
    this.vu = obj["vu"];
  }
}