class Contact {
  String id;
  String email;
  String userName;
  String urlImage;
  String password;
  String statut;
  String lastmessage;
  String message;
  String emetteur;
  String lu;
  bool isSelected = false;
  int indice;
  String optionVu;
  //Contact(this.email, this.urlImage, this.lastmessage);
  Contact(this.email, this.optionVu,this.userName);
  Contact.fromJson(dynamic obj) {
    id = obj["id"];
    email = obj["email"];
    userName = obj["userName"];
    urlImage = obj["urlImage"];
    statut = obj["statut"];
  }
  Contact.fromFirestore(dynamic data) {
    email = data["emetteur"];
    userName = data["userName"];
    urlImage = data["urlImage"];
    lastmessage = data["lastmessage"];
    statut = data["statut"];
    lu = data["lu"];
  }
  // ignore: non_constant_identifier_names
  ContactToMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["email"] = this.email;
    map["optionVu"] = this.optionVu;
    map["userName"] = this.userName;
    return map;
  }

  // ignore: non_constant_identifier_names
  MessageToMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map["email"] = this.email;
    map["userName"] = this.userName;
    map["message"] = this.message;
    map["emetteur"] = this.emetteur;
    return map;
  }

  // ignore: non_constant_identifier_names
  Contact.fromMap(Map<String, dynamic> map) {
    email = map["email"];
    urlImage = map["optionVu"];
    userName = map["userName"];
  }
  Contact.fromMessageMap(Map<String, dynamic> map) {
    email = map["email"];
    userName = map["userName"];
    message = map["message"];
    emetteur = map["emetteur"];
  }
  Contact.fromContactsMap(Map<String, dynamic> map) {
    email = map["email"];
    urlImage = map["urlImage"];
  }
}
