import 'package:chat/models/Contact.dart';

class Groupe {
  String nom;
  String lastMessage;
  List<Contact> members;
  String nomMemeber;
  String imageMemeber;
  String emailMember;

  Groupe(this.nom);
  Groupe.fromFirestore(dynamic data) {
    nom = data["nom"];
  }
  Groupe.fromMembers(dynamic data){
    emailMember = data["email"];
    imageMemeber = data["image"];
    nomMemeber = data["nom"];
  }
}