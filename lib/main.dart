import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radiounal2/src/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {

  WidgetsFlutterBinding.ensureInitialized(); // Asegúrate de inicializar Flutter


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );


  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((value) => runApp(const MyApp()));


}
