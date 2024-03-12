
import 'package:flutter/material.dart';
import 'package:radiounal2/src/presentation/patials/bottom_navigation_bar_radio.dart';

import 'data/models/programacion_model.dart';
import 'presentation/home.dart';
import 'business_logic/firebase/push_notifications.dart';
import 'package:radiounal2/src/business_logic/ScreenArguments.dart';



class MyApp extends StatefulWidget {

  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  GlobalKey<BottomNavigationBarRadioState> keyPlayer = GlobalKey();
  List<ProgramacionModel> pragramacionList = [];

  @override
  void initState() {
    initPushNotifications();

  }

  void initPushNotifications() {
    final pushNotification = new PushNotification();
    pushNotification.initNotifications();

    //Cuando el usuario presiona la push Notification se llema este bloque de código
    // Llega el Uid de la serie o programa enviado desde el backend de radio y podcast
    pushNotification.mensajes.listen((data) {

      if (data != null) {
        var messageStr = data['site'];
        var redirectTo = "/item";
        var uid = int.parse(data['uid'].toString());

        navigatorKey.currentState?.pushNamed(redirectTo,
            arguments: ScreenArguments("SITE", messageStr, uid,
                from: "BROWSER_RESULT_PAGE"));
      }
    });
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
                child: Text("017- push notifications", style: TextStyle(color: Colors.red))
            )
          ],
        )

    );

  }


}
