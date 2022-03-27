import 'package:chat/Screens/Connexion.dart';
import 'package:chat/Screens/CreateGroup.dart';
import 'package:chat/Screens/HomeMessage.dart';
import 'package:chat/Screens/HommeGroup.dart';
import 'package:chat/Screens/LoginScreen.dart';
import 'package:chat/Screens/Messages.dart';
import 'package:chat/Screens/Profile.dart';
import 'package:chat/Screens/groupCreation.dart';
import 'package:chat/Screens/splashcreen.dart';
import 'package:chat/models/Contact.dart';
import 'package:chat/models/Groupe.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Screens/GroupSetting.dart';

class GeneratedRoutes {
  static const String home = "/home";
  static const String loginScreen = "/";
  static const String signIn = "/singIn";
  static const String splash = "/splashScreen";
  static const String message = "/message";
  static const String groupe = "/groupe";
  static const String create = "/create";
  static const String homeGroup = "/homeGroup";
  static const String quit = "/quit";
  static const String profile = "/profile";
  static Route<dynamic> onGeneratedRoute(RouteSettings settings) {
    switch (settings.name) {
      case loginScreen:
        return MaterialPageRoute(builder: (context) => LoginScreen());
      case home:
        return MaterialPageRoute(builder: (context) => HomeMessage());
      case signIn:
        return MaterialPageRoute(builder: (context) => Login());
      case splash:
        return MaterialPageRoute(builder: (context) => Splashcreen());
      case groupe:
        return MaterialPageRoute(builder: (context) => GroupCreate());
      case create:
        return MaterialPageRoute(builder: (context) => CreateGroup());
      case quit:
        {
          List<String> list = settings.arguments;
          return MaterialPageRoute(builder: (context) => Quit(list));
        }
      case homeGroup:
        {
          Groupe groupe = settings.arguments;
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => HommeGroupe(groupe));
        }
      case message:
        {
          Contact contact = settings.arguments;
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => UserMessage(contact));
        }
        case profile:
        {
          Contact contact = settings.arguments;
          return PageRouteBuilder(
              pageBuilder: (_, __, ___) => Profile(contact));
        }
      default:
        return MaterialPageRoute(builder: (context) => null);
    }
  }
}
