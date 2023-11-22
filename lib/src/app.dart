
import 'package:flutter/material.dart';
import 'package:radiounal2/src/presentation/patials/bottom_navigation_bar_radio.dart';

import 'data/models/programacion_model.dart';
import 'presentation/home.dart';


class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  GlobalKey<BottomNavigationBarRadioState> keyPlayer = GlobalKey();
  List<ProgramacionModel> pragramacionList = [];

  @override
  void initState() {

  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:
        Stack(
          children: [
             Home(
                keyPlayer.currentState?.playMusic,
                 pragramacionList
             ),
            /*Positioned(
                bottom: 0, child: BottomNavigationBarRadio(key: keyPlayer)),*/
            Container(
                alignment: Alignment.center,
                child: Text("010- initial reproducer", style: TextStyle(color: Colors.red))
            )
          ],
        )

    );

  }


}
