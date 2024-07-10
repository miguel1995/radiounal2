import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal2/src/business_logic/ScreenArguments.dart';
import 'package:radiounal2/src/business_logic/bloc/podcast_series_bloc.dart';
import 'package:radiounal2/src/business_logic/bloc/radio_programas_bloc.dart';
import 'package:radiounal2/src/data/models/info_model.dart';
import 'package:radiounal2/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal2/src/presentation/partials/menu.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../partials/favorito_btn.dart';

class ContentPage extends StatefulWidget {
  final String title;
  final String message;
  final int page;

  const ContentPage(
      {Key? key,
      required this.title,
      required this.message,
      required this.page})
      : super(key: key);

  @override
  State<ContentPage> createState() => _ContentPageState();
}

class _ContentPageState extends State<ContentPage> {
  late String title;
  late String message;
  late int page;
  bool isLoading = false;
  List elementList = [];

  final blocRadioProgramas = RadioProgramasBloc();
  final blocPodcastSeries = PodcastSeriesBloc();

  var size = null;
  double paddingTop = 0;
  ScrollController _scrollController = ScrollController();
  List<Widget> cardList = [];

  int totalPages = 0;
  late FavoritoBtn favoritoBtn;
  bool isDarkMode = false;

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  void initState() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    super.initState();

    title = widget.title;
    message = widget.message;
    page = widget.page;

    if (message == "RADIO") {
      blocRadioProgramas.fetchProgramas(page);
    } else if (message == "PODCAST") {
      blocPodcastSeries.fetchSeries(page);
    }

    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (page < totalPages) {
          page++;

          if (message == "RADIO") {
            blocRadioProgramas.fetchProgramas(page);
          } else {
            blocPodcastSeries.fetchSeries(page);
          }

          setState(() {
            isLoading = true;
          });

          Future.delayed(Duration(milliseconds: 3000), () {
            setState(() {
              isLoading = false;
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    themeMethod().then((value) {
      setState(() {
        isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });
    size = MediaQuery.of(context).size;
    paddingTop = size.width * 0.30;

    return Scaffold(
      backgroundColor: isDarkMode ? Color(0xFF121C4A) : Color(0xff121C4A),
      //extendBodyBehindAppBar: true,
      endDrawer: const Menu(),
      appBar: AppBarRadio(enableBack: true),
      body: DecoratedBox(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(isDarkMode
                  ? "assets/images/FONDO_AZUL_REPRODUCTOR.png"
                  : "assets/images/fondo_blanco_amarillo.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: StreamBuilder(
              stream: (message == "RADIO")
                  ? blocRadioProgramas.subject.stream
                  : blocPodcastSeries.subject.stream,
              builder: (BuildContext context,
                  AsyncSnapshot<Map<String, dynamic>> snapshot) {
                Widget child;

                if (snapshot.hasData) {
                  child = drawContentList(snapshot);
                } else if (snapshot.hasError) {
                  child = drawError(snapshot.error);
                } else {
                  child = const Center(
                      child: SpinKitFadingCircle(
                    color: Color(0xffb6b3c5),
                    size: 50.0,
                  ));
                }
                return child;
              })),
    );
  }

  @override
  void dispose() {
    blocPodcastSeries.dispose();
    blocRadioProgramas.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Widget drawContentList(AsyncSnapshot<Map<String, dynamic>> snapshot) {
    InfoModel infoModel;
    infoModel = snapshot.data!["info"];
    totalPages = infoModel.pages;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              (message == "RADIO")
                  ? ("Programas Radio UNAL")
                  : ("Series Podcast Radio UNAL"),
              style: TextStyle(
                shadows: [
                  Shadow(
                      color: isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF121C4A),
                      offset: const Offset(0, -5))
                ],
                color: Colors.transparent,
                decorationThickness: 2,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                decorationColor: const Color(0xFFFCDC4D),
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.only(left: 20, top: 3, bottom: 3),
            child: Text(
              "${infoModel.count} resultados",
              style: TextStyle(
                color: isDarkMode ? Color(0xFFFFFFFF) : Color(0xFF121C4A),
                fontSize: 12,
                fontWeight: FontWeight.bold,
                decorationColor:
                    isDarkMode ? Color(0xff121C4A) : Color(0xFFFCDC4D),
              ),
            ),
          ),
          /*Container(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Página ${page} de ${infoModel.pages}",
                    style: const TextStyle(
                      color: Color(isDarkMode?:0xFFFCDC4D:0xff121C4A),
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      decorationColor: Color(isDarkMode?0xff121C4A:0xFFFCDC4D),
                    ),
                  ),
                ),*/
          Expanded(child: buildList(snapshot, isDarkMode)),
          if (isLoading)
            const Center(
                child: SpinKitFadingCircle(
              color: Color(0xffb6b3c5),
              size: 50.0,
            ))
        ]);
  }

  Widget drawError(error) {
    return Container(
      child: Column(
        children: <Widget>[
          const Icon(
            Icons.error_outline,
            color: Colors.red,
            size: 60,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Text('Error: ${error}'),
          )
        ],
      ),
    );
  }

  Widget buildList(
      AsyncSnapshot<Map<String, dynamic>> snapshot, bool isDarkMode) {
    var list = snapshot.data!["result"];

    list?.forEach((element) => {
          if (!elementList.contains(element))
            {cardList.add(buildCard(element)), elementList.add(element)}
        });

    return GridView.count(
        controller: _scrollController, crossAxisCount: 2, children: cardList);
  }

  Widget buildCard(element) {
    var w = MediaQuery.of(context).size.width;

    return InkWell(
        onTap: () {
          Navigator.pushNamed(context, "/detail",
              arguments: ScreenArguments(title, message, element.uid,
                  element: element));
        },
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 20),
            child: Column(
              children: [
                Expanded(
                    child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(30),
                    child: AspectRatio(
                        aspectRatio: 1.0, // Relación de aspecto 1:1 (cuadrado)
                        child: CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: element.imagen,
                          placeholder: (context, url) => Text(""),
                          errorWidget: (context, url, error) =>
                              Image.asset("assets/images/default.png"),
                        )),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Color(0xFFFCDC4D),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset:
                            const Offset(5, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    element.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xff121C4A)),
                  ),
                )
              ],
            )));
  }
}
