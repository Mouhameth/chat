class MessageGp{
  String nom;
  String email;
  String message;
  bool isMe;
  String isImage;

  MessageGp(this.nom,this.email,this.message, this.isMe,this.isImage);
  MessageGp.fromJson(dynamic obj){
    this.email= obj["emetteur"];
    this.nom= obj["nom"];
    this.isImage = obj["isImage"];
    this.message = obj["message"];
  }
}