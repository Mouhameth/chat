import 'dart:io';
import 'package:chat/Utils/DataBaseHelper.dart';
import 'package:chat/models/Contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class Networking {
  static String url;
  static Future<int> inscription(String email, String mdp) async {
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: mdp);
      if (user != null) return 1;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return -1;
      }
    }
  }

  static Future<int> connexion(String email, String mdp) async {
    DataBaseHelper helper = DataBaseHelper();

    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: mdp);
      if (user != null) {
        return 1;}
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return -1;
      } else if (e.code == 'wrong-password') {
        return 0;
      }
    }
  }

  static Future<int> saveProfileAndData(File file, String fname, String lname,
      String email, String password) async {
    DataBaseHelper helper = DataBaseHelper();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    firebase_storage.Reference storage = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("image/profile" + email);
    await storage.putFile(file).whenComplete(() async {
      await storage.getDownloadURL().then((value) async {
        url = value;
        Contact contact = Contact(email,"false",fname + " " + lname);
        await helper.insertUser(contact);
        users
            .doc(email)
            .set({
              'id': email,
              'email': email,
              'userName': fname + " " + lname,
              'urlImage': url,
              'statut': "Online",
            })
            .then((value) => print("user added!"))
            .catchError((error) => print("Failed to add user: $error"));
      });
    });
    if (url != null) return 1;

    return 0;
  }

  static Future<void> updateStatus(String email, String status) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(email)
        .update({'statut': status})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  static Future<void> updateVu(String email,String recept,String id) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(email)
        .collection(recept)
        .doc(id)
        .update({'vu': 'true'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  static Future<void> updateImage(String email, File file) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    firebase_storage.Reference storage = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child("image/profile" + email);
    await storage.putFile(file).whenComplete(() async {
      await storage.getDownloadURL().then((val) async {
        print(val);
        return await users
            .doc(email)
            .update({'urlImage': val})
            .then((value) => print("User Updated"))
            .catchError((error) => print("Failed to update user: $error"));
      });
    });
  }

  static Future<int> envoyerMessage(String emetteur, String recepteur,
      String message, bool isImage, File file) async {
    var now = DateTime.now();
    int ins =0;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (isImage == false) {
      await users
          .doc(emetteur)
          .collection(recepteur)
          .doc(recepteur + "" + now.toString())
          .set({'message': message, 'emetteur': emetteur, 'isImage': 'false',
          'id':emetteur + "" + now.toString(),'vu':'false'})
          .then((value) => 1)
          .catchError((onError) => 0);
      if (users != null)
        return 1;
      else
        return 0;
    } else {
      firebase_storage.Reference storage = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("image/profile" + message);
      await storage.putFile(file).whenComplete(() async {
        await storage
            .getDownloadURL()
            .then((value) async {
              url = value;
              users
                  .doc(emetteur)
                  .collection(recepteur)
                  .doc(recepteur + "" + now.toString())
                  .set(
                      {'message': url, 'emetteur': emetteur, 'isImage': 'true',
                      'id':emetteur + "" + now.toString(),'vu':'false'})
                  .then((value) => 1)
                  .catchError((onError) => 0);
              if (users != null)
                ins = 1;
              
            })
            .then((value) => print("user added!"))
            .catchError((error) => print("Failed to add user: $error"));
      });
      return ins;
    }
  }

  static Future<int> lastMessage(String email, String recepteur, String name,
      String url, String lastmsg, String statut) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).collection("message").doc(recepteur).set({
      "emetteur": recepteur,
      "userName": name,
      "lastmessage": lastmsg,
      "urlImage": url,
      "statut": statut,
    });
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> lastMessageExp(String email, String recepteur, String name,
      String url, String lastmsg, String statut) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).collection("message").doc(recepteur).set({
      "emetteur": recepteur,
      "userName": name,
      "lastmessage": lastmsg,
      "urlImage": url,
      "statut": statut,
      "lu":'false'
    });
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<void> updateLu(String email,String recept) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return await users
        .doc(email)
        .collection("message")
        .doc(recept)
        .update({'lu': 'true'})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
    static Future<int> createGroup(String email, String nom) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).collection("groupes").doc(nom).set({
      "nom": nom
    });
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> insertMember(String email, String nom, List<Contact> list) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for(int i = 0;i<list.length;i++)
      await users.doc(email).collection("groupes").doc(nom).collection("member").doc(list[i].email).set({
        "nom": list[i].userName,
        "email":list[i].email,
        "image":list[i].urlImage,
      });
    await users.doc(email).collection("groupes").doc(nom).collection("member").doc(email).set({
      "email":email
  
    });
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> createGroupForOthers(List<Contact> list,String email, String nom) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for(int i = 0;i<list.length;i++)
    await users.doc(list[i].email).collection("groupes").doc(nom).set({
      "nom": nom
    });
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> insertMemberForOthers(String email, String nom, List<Contact> list) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    for(int i = 0;i<list.length;i++){
      for(int j = 0;j<list.length;j++)
          await users.doc(list[i].email).collection("groupes").doc(nom).collection("member").doc(list[j].email).set({
            "nom": list[j].userName,
            "email":list[j].email,
            "image":list[j].urlImage,
          });
    await users.doc(list[i].email).collection("groupes").doc(nom).collection("member").doc(email).set({
      "email":email
    });}
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> quitterGroupe(String email,String nom) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).collection("groupes").
    doc(nom).collection("member").doc(email).delete()
    .then((value) => print("User Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> quitterOtherGroupe(String email,String emq,String nom) async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.doc(email).collection("groupes").
    doc(nom).collection("member").doc(emq).delete()
    .then((value) => print("User Deleted"))
    .catchError((error) => print("Failed to delete user: $error"));
    if (users != null)
      return 1;
    else
      return 0;
  }
  static Future<int> envoyerMessageGroupe(String emetteur,String userName, String nom,
      String message, bool isImage, File file) async {
    var now = DateTime.now();
    int ins =0;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    if (isImage == false) {
      await users
          .doc(emetteur)
          .collection("groupes")
          .doc(nom)
          .collection("messages")
          .doc(emetteur + "" + now.toString())
          .set({'message': message, 'emetteur': emetteur, 'isImage': 'false','userName':userName
          })
          .then((value) => 1)
          .catchError((onError) => 0);
      if (users != null)
        return 1;
      else
        return 0;
    } else {
      firebase_storage.Reference storage = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child("image/profile" + message);
      await storage.putFile(file).whenComplete(() async {
        await storage
            .getDownloadURL()
            .then((value) async {
              url = value;
              users
                  .doc(emetteur)
                  .collection("groupes")
                  .doc(nom)
                  .collection("messages")
                  .doc(emetteur + "" + now.toString())
                  .set(
                      {'message': url, 'emetteur': emetteur, 'isImage': 'true',
                      'userName': userName})
                  .then((value) => 1)
                  .catchError((onError) => 0);
              if (users != null)
                ins = 1;
              
            })
            .then((value) => print("user added!"))
            .catchError((error) => print("Failed to add user: $error"));
      });
      return ins;
    }
  }
}
