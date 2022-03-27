import 'package:chat/models/Contact.dart';
import 'package:chat/models/Message.dart';
import 'package:chat/models/messageGp.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class LoginProviders extends ChangeNotifier {
  PickedFile file;
  TextEditingController fnamecontrol = new TextEditingController();
  TextEditingController lnamecontrol = new TextEditingController();
  TextEditingController emailcontrol = new TextEditingController();
  TextEditingController passcontrol = new TextEditingController();
  TextEditingController cpasscontrol = new TextEditingController();
  int index = 1;
  int send = 0;
  String textSearch;
  List<Contact> contactSearch;
  List<Message> messages = [];
  List<MessageGp> message = [];
  ImagePicker imagePicker = new ImagePicker();
  GlobalKey<FormState> keyForm = new GlobalKey<FormState>();
  List<Contact> listMember = [];
  int indice = 0;
  int cliklu = 0;
  getNewImage() async {
    file = await imagePicker.getImage(source: ImageSource.gallery);
    notifyListeners();
  }

  changeIntent(int ind) {
    index = ind;
    notifyListeners();
  }

  chnageState() {
    notifyListeners();
  }

  select(int i) {
    
      listMember[indice].indice = i;
      listMember[indice].isSelected = true;
      indice ++;
    
    notifyListeners();
  }

  search(String search) async {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    textSearch = search;
    if (search != null)
      await _firestore
          .collection("users")
          .where("userName", isEqualTo: search)
          .get()
          .then((value) {
        if (value.docs.isNotEmpty) {
          contactSearch = [];
          for (int i = 0; i < value.docs.length; i++)
            contactSearch.add(Contact.fromJson(value.docs[i].data()));
        }
      });
    if (search.length == 0) {
      textSearch = null;
      if (contactSearch != null) contactSearch.clear();
    }
    notifyListeners();
  }
}
