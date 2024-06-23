
import 'package:flutter/material.dart';
import 'package:radiounal2/src/presentation/patials/bottom_navigation_bar_radio.dart';

import 'data/models/programacion_model.dart';
import 'presentation/home.dart';
import 'business_logic/firebase/push_notifications.dart';
import 'package:radiounal2/src/business_logic/ScreenArguments.dart';
import 'package:radiounal2/src/presentation/splash.dart';



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
    /*return AdaptiveTheme(
        dark: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.red,
            primaryColor: Color(0xFFFCDC4D),
            primaryColorDark:
            isDarkMode ? const Color(0xff121C4A) : const Color(0xFFFCDC4D),
            fontFamily: 'AncizarSans',
            textTheme: const TextTheme(
              // bodyText2: TextStyle(
              //     // fontSize: 14.0,
              //       fontWeight: FontWeight.bold,
              //     color: Colors.white),
              headline1: TextStyle(
                // fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            appBarTheme: AppBarTheme(
                color: Color(0xFFFCDC4D), foregroundColor: Color(0xff121C4A)
              //color: Color(isDarkMode?0xff121C4A:0xFFFCDC4D),
              // backgroundColor: Color(isDarkMode?:0xFFFCDC4D:0xff121C4A),
              // foregroundColor:Color(isDarkMode?0xff121C4A:0xFFFCDC4D)
            ),
            drawerTheme: DrawerThemeData(
                backgroundColor:
                isDarkMode ? Color(0xFFFCDC4D) : Color(0xff121C4A))),
        light: ThemeData(
          // Define the default brightness and colors.
            brightness: Brightness.light,
            primaryColor: Color(0xff121C4A),

            // Define the default font family.
            fontFamily: 'AncizarSans',
            textTheme: TextTheme(
                headline1: const TextStyle(
                  // fontSize: 72.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
                headline2: const TextStyle(color: Colors.red),
                headline3: const TextStyle(color: Colors.red),
                headline4: const TextStyle(color: Colors.red),
                headline5: const TextStyle(color: Colors.red),
                headline6: const TextStyle(
                  // fontSize: 36.0,
                    fontStyle: FontStyle.italic,
                    color: Colors.red),
                bodyText1: const TextStyle(color: Colors.red),
                bodyText2: TextStyle(
                  // fontSize: 14.0,
                    color: Color(isDarkMode ? 0xFFFCDC4D : 0xff121C4A))),
            appBarTheme: AppBarTheme(
                color: isDarkMode ? Color(0xFFFCDC4D) : Color(0xff121C4A),
                foregroundColor:
                isDarkMode ? Color(0xff121C4A) : Color(0xFFFCDC4D)),
            drawerTheme: DrawerThemeData(
                backgroundColor:
                isDarkMode ? Color(0xFFFCDC4D) : Color(0xff121C4A))),
        initial: AdaptiveThemeMode.light,
        builder: (theme, darkTheme) {*/
          return MaterialApp(
            navigatorKey: navigatorKey,
            //theme: theme,
            //Tema Oscuro, se usa cuando se activa el modo oscuro
            //darkTheme: darkTheme,
            title: 'Radio UNAL',
            debugShowCheckedModeBanner: false,
            builder: (context, Widget? childElement) {
              return Scaffold(
                  body: Stack(children: [
                    if (childElement != null)
                      Container(
                          padding: const EdgeInsets.only(bottom: 96),
                          child: childElement),
                    Container(
                        alignment: Alignment.center,
                        child: Text("22 - play mini reproductor ", style: TextStyle(color: Colors.red))
                    ),

                    Positioned(
                        bottom: 0, child: BottomNavigationBarRadio(key: keyPlayer)),
                    Splash()
                  ]));
            },
            initialRoute: "/",
            onGenerateRoute: (settings) {
              if (settings.name == '/') {
                return MaterialPageRoute(builder: (context) {
                  return WillPopScope(
                      onWillPop: () async {
                        // Devuelve un valor "false" para deshabilitar el botón de retroceso
                        return Future.value(false);
                      },
                      child: Home(
                          keyPlayer.currentState?.playMusic, pragramacionList));
                });
              }

              /*else if (settings.name == '/browser') {
                return MaterialPageRoute(builder: (context) {
                  return BrowserPage();
                });
              } else if (settings.name == '/configurations') {
                return MaterialPageRoute(builder: (context) {
                  return ConfigurationsPage();
                });
              } else if (settings.name == '/about') {
                return MaterialPageRoute(builder: (context) {
                  return AboutPage();
                });
              } else if (settings.name == '/contacts') {
                return MaterialPageRoute(builder: (context) {
                  return ContactsPage();
                });
              } else if (settings.name == '/politics') {
                return MaterialPageRoute(builder: (context) {
                  return PoliticsPage();
                });
              } else if (settings.name == '/credits') {
                return MaterialPageRoute(builder: (context) {
                  return CreditsPage();
                });
              } else if (settings.name == "/content") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return ContentPage(
                      title: args.title,
                      message: args.message,
                      page: args.number,
                    );
                  },
                );
              } else if (settings.name == "/detail") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return DetailPage(
                      title: args.title,
                      message: args.message,
                      uid: args.number,
                      elementContent: args.element,
                    );
                  },
                );
              } else if (settings.name == "/item") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return ItemPage(
                        title: args.title,
                        message: args.message,
                        uid: args.number,
                        from: args.from,
                        callBackPlayMusic: keyPlayer.currentState?.playMusic);
                  },
                );
              } else if (settings.name == "/browser-result") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return BrowserResultPage(
                        title: args.title,
                        message: args.message,
                        page: args.number,
                        element: args.element);
                  },
                );
              } else if (settings.name == "/favourites") {
                final args = settings.arguments as ScreenArguments;

                return MaterialPageRoute(
                  builder: (context) {
                    return TabMenuPage(
                      tabIndex: args.number,
                    );
                  },
                );
              } else if (settings.name == "/followed") {
                final args = settings.arguments as ScreenArguments;
                return MaterialPageRoute(
                  builder: (context) {
                    return TabMenuPage(
                      tabIndex: args.number,
                    );
                  },
                );
              }*/

              assert(false, 'Need to implement ${settings.name}');
              return null;
            },
          );

       /* });*/
  }


 /* @override
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
            //Positioned(
              //  bottom: 0, child: BottomNavigationBarRadio(key: keyPlayer)),
            Container(
                alignment: Alignment.center,
                child: Text("018- draw programacion", style: TextStyle(color: Colors.red))
            )
          ],
        )

    );

  }*/


}
