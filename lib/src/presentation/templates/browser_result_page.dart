import 'dart:math';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:radiounal2/src/business_logic/bloc/elastic_search_bloc.dart';
import 'package:radiounal2/src/business_logic/bloc/radio_search_bloc.dart';
import 'package:radiounal2/src/data/models/emision_model.dart';
import 'package:radiounal2/src/data/models/episodio_model.dart';
import 'package:radiounal2/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal2/src/presentation/partials/menu.dart';
import 'package:radiounal2/src/presentation/partials/multi_tab_result.dart';
import 'package:rxdart/rxdart.dart';

import '../../business_logic/ScreenArguments.dart';
import '../../business_logic/bloc/podcast_masescuchados_bloc.dart';
import '../../business_logic/bloc/podcast_search_bloc.dart';
import '../../business_logic/bloc/podcast_series_bloc.dart';
import '../../business_logic/bloc/radio_masescuchados_bloc.dart';
import '../../data/models/info_model.dart';

class BrowserResultPage extends StatefulWidget {
  String title;
  String message;
  dynamic element;
  late int page;

  BrowserResultPage(
      {Key? key,
      required this.title,
      required this.message,
      required this.page,
      this.element})
      : super(key: key);

  @override
  State<BrowserResultPage> createState() => _BrowserResultPageState();
}

class _BrowserResultPageState extends State<BrowserResultPage> {
  late String title;
  late String message;
  dynamic elementFilters;
  late int page;

  final blocRadioSearch = RadioSearchBloc();
  final blocRadioMasEscuchados = RadioMasEscuchadosBloc();
  final blocPodcastMasEscuchados = PodcastMasEscuchadosBloc();
  final blocPodcastSeries = PodcastSeriesBloc();
  final blocElasticSearch = ElasticSearchBloc();
  final blocPodcastSearch = PodcastSearchBloc();

  var size = null;
  double paddingTop = 0;
  final ScrollController _scrollController = ScrollController();
  var querySize = 0;
  var start = 0;
  List<Widget> cardList = [];
  List elementList = [];

  int totalPages = 0;
  bool isLoading = false;
  bool isDarkMode = false;

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  void initState() {
    var brightness = SchedulerBinding.instance.window.platformBrightness;
    isDarkMode = brightness == Brightness.dark;
    title = widget.title;
    message = widget.message;
    elementFilters = widget.element;
    page = widget.page;

    if (elementFilters["contentType"] == "MASESCUCHADO") {
      blocRadioMasEscuchados.fetchMasEscuchados();
      blocPodcastMasEscuchados.fetchMasEscuchados();
    } else if (elementFilters["contentType"] == "PROGRAMAS" ||
        elementFilters["contentType"] == "EMISIONES") {
      blocRadioSearch.fetchSearch(
          elementFilters["query"],
          page,
          elementFilters["sede"],
          elementFilters["canal"],
          elementFilters["area"],
          elementFilters["contentType"]);
    } else if (elementFilters["contentType"] == "SERIES") {
      blocPodcastSeries.fetchSeries(page);
    } else if (elementFilters["contentType"] == "EPISODIOS") {
      blocPodcastSearch.fetchSearch(elementFilters["query"], page, "EPISODIOS");
    } else if (elementFilters["contentType"] == "ELASTIC") {
      //TODO: 11/05/2023 Descomentar cuando el servicio de ELASTIC sea reestablecido
      /*querySize = 100;
        start = page * querySize;
        blocElasticSearch.fetchSearch(elementFilters["query"], page, start);*/

      //TODO: 11/05/2023 Se deja la busqueda  generica para radio mientras regrasa el servicio ELASTIC
      /*blocRadioSearch.fetchSearch(
            elementFilters["query"],
            page,
            0, //Buca en todas las sedes
            "TODOS",
            "TODOS",
            "EMISIONES");*/
    }

    initializeScrollListener();
    initializeStopLoading();
  }

  void initializeScrollListener() {
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent ==
          _scrollController.offset) {
        if (page < totalPages) {
          page++;

          setState(() {
            isLoading = true;
          });

          if (elementFilters["contentType"] == "PROGRAMAS" ||
              elementFilters["contentType"] == "EMISIONES") {
            blocRadioSearch.fetchSearch(
                elementFilters["query"],
                page,
                elementFilters["sede"],
                elementFilters["canal"],
                elementFilters["area"],
                elementFilters["contentType"]);
          } else if (elementFilters["contentType"] == "ELASTIC") {
            //start = page * querySize;

            /*blocElasticSearch.fetchSearch(
                elementFilters["query"], start, querySize);*/
            //TODO: 14/05/2023 Se deja la busqueda  generica para radio mientras regrasa el servicio ELASTIC
            /*blocRadioSearch.fetchSearch(
                elementFilters["query"],
                page,
                0, //Buca en todas las sedes
                "TODOS",
                "TODOS",
                "EMISIONES");*/
          } else if (elementFilters["contentType"] == "SERIES") {
            blocPodcastSeries.fetchSeries(page);
          } else if (elementFilters["contentType"] == "EPISODIOS") {
            blocPodcastSearch.fetchSearch(
                elementFilters["query"], page, "EPISODIOS");
          }
        }
      }
    });
  }

  void initializeStopLoading() {
    blocPodcastSeries.subject.stream.listen((event) {
      if (event.values.isNotEmpty) {
        /*setState(() {
          isLoading = false;
        });*/
      }
    });

    blocRadioSearch.subject.stream.listen((event) {
      if (event.values.isNotEmpty) {
        /*setState(() {
          isLoading = false;
        });*/
      }
    });

    blocElasticSearch.subject.stream.listen((event) {
      if (event.values.isNotEmpty) {
        /*setState(() {
          isLoading = false;
        });*/
      }
    });

    blocPodcastSearch.subject.stream.listen((event) {
      if (event.values.isNotEmpty) {
        /*setState(() {
          isLoading = false;
        });*/
      }
    });
  }

  Future<bool> setFalseLoadig() async {
    return false;
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
        extendBodyBehindAppBar: true,
        endDrawer: Menu(),
        appBar: AppBarRadio(enableBack: true),
        body: Container(
            padding: EdgeInsets.only(top: 120),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(isDarkMode
                    ? "assets/images/FONDO_AZUL_REPRODUCTOR.png"
                    : "assets/images/fondo_blanco_amarillo.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: drawContent()));
  }

  @override
  void dispose() {
    blocRadioSearch.dispose();
    blocRadioMasEscuchados.dispose();
    blocPodcastMasEscuchados.dispose();
    blocPodcastSeries.dispose();
    blocElasticSearch.dispose();
    blocPodcastSearch.dispose();

    super.dispose();
  }

  Widget drawContent() {
    Widget widget;

    if (elementFilters["contentType"] == "MASESCUCHADO") {
      widget = StreamBuilder(
          stream: CombineLatestStream.list([
            blocRadioMasEscuchados.subject.stream,
            blocPodcastMasEscuchados.subject.stream,
          ]),
          builder:
              (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
            Widget child;

            if (snapshot.hasData) {
              child = drawListEscuchados(snapshot);
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
          });
    } else if (elementFilters["contentType"] == "ELASTIC") {
      widget = Container(child: getMultiTabResult());
    } else {
      var blocStream = null;
      if (elementFilters["contentType"] == "SERIES") {
        blocStream = blocPodcastSeries.subject.stream;
      } else if (elementFilters["contentType"] == "EPISODIOS") {
        blocStream = blocPodcastSearch.subject.stream;
      } else {
        blocStream = blocRadioSearch.subject.stream;
      }
      widget = StreamBuilder(
          stream: blocStream,
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
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
          });
    }

    return widget;
  }

  Widget drawContentList(AsyncSnapshot<dynamic> snapshot) {
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
              message,
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
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "${infoModel.count} resultados",
              style: TextStyle(
                color: isDarkMode ? Color(0xFFFFFFFF) : Color(0xff121C4A),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                decorationColor: Color(isDarkMode ? 0xff121C4A : 0xFFFCDC4D),
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
          Expanded(
              child: (elementFilters["numColumn"] == 1)
                  ? buildVerticalList(snapshot)
                  : buildGridList(snapshot)),
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

  Widget buildGridList(AsyncSnapshot<dynamic> snapshot) {
    var list = snapshot.data!["result"];

    for (var i = 0; i < list.length; i++) {
      if (!elementList.contains(list[i])) {
        setFalseLoadig().then((value) => {
              setState(() {
                isLoading = false;
              })
            });
        cardList.add(buildCardForGridList(list[i]));
        elementList.add(list[i]);
      }
    }

    return GridView.count(
        padding: EdgeInsets.zero,
        controller: _scrollController,
        crossAxisCount: 2,
        children: cardList);
  }

  Widget buildVerticalList(AsyncSnapshot<dynamic> snapshot) {
    var list = snapshot.data!["result"];
    list?.forEach((element) => {
          if (!elementList.contains(element))
            {
              setFalseLoadig().then((value) => {
                    setState(() {
                      isLoading = false;
                    })
                  }),
              cardList.add(buildCardForVerticalList(element)),
              elementList.add(element)
            }
        });

    return ListView(
      padding: EdgeInsets.only(top: 0),
        shrinkWrap: true, controller: _scrollController, children: cardList);
  }

  Widget buildCardForGridList(element) {

    return InkWell(
        onTap: () {
          if (elementFilters["contentType"] == "SERIES") {
            Navigator.pushNamed(context, "/detail",
                arguments: ScreenArguments("SITE", "PODCAST", element.uid,
                    element: element));
          } else if (elementFilters["contentType"] == "PROGRAMAS") {
            Navigator.pushNamed(context, "/detail",
                arguments: ScreenArguments("SITE", "RADIO", element.uid,
                    element: element));
          } else if (elementFilters["contentType"] == "EMISIONES") {
            Navigator.pushNamed(context, "/item",
                arguments: ScreenArguments("SITE", "RADIO", element.uid,
                    element: element));
          } else if (elementFilters["contentType"] == "EPISODIOS") {
            Navigator.pushNamed(context, "/item",
                arguments: ScreenArguments("SITE", "PODCAST", element.uid,
                    from: "BROWSER_RESULT_PAGE"));
          } else if (elementFilters["contentType"] == "MASESCUCHADO") {
            Navigator.pushNamed(context, "/item",
                arguments: ScreenArguments(
                    "SITE",
                    (element is EpisodioModel) ? "PODCAST" : "RADIO",
                    element.uid,
                    from: "BROWSER_RESULT_PAGE"));
          }
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
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: (elementFilters["contentType"] == "ELASTIC")
                            //TODO: descomentar cuando elastic se reestablesca
                            //? element["_source"]["imagen"]
                            ? element.imagen
                            : element.imagen,
                        placeholder: (context, url) => Text(""),
                        errorWidget: (context, url, error) =>
                            Image.asset("assets/images/default.png"),
                      ),
                    ),
                  ),
                )),
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFCDC4D),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset:
                            const Offset(5, 5), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Text(
                    (elementFilters["contentType"] == "ELASTIC")
                        //TODO:14/05/23 descomentar cuando  servicio elastic se reestablesca
                        //? element["_source"]["title"] ?? ""
                        ? element.title
                        : element.title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF121C4A)),
                  ),
                )
              ],
            )));
  }

  Widget drawListEscuchados(AsyncSnapshot<List<dynamic>> snapshot) {
    var list1 = snapshot.data![0];
    var list2 = snapshot.data![1];
    var countEscuchados = list1.length + list2.length;

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(left: 20, top: 20),
            child: Text(
              message,
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
            padding: const EdgeInsets.only(left: 20),
            child: Text(
              "${countEscuchados} resultados",
              style: const TextStyle(
                color: Color(0xff121C4A),
                fontSize: 10,
                fontWeight: FontWeight.bold,
                decorationColor: Color(0xFFFCDC4D),
              ),
            ),
          ),
          Expanded(child: buildListEscuchados(list1, list2)),
          if (isLoading)
            const Center(
                child: SpinKitFadingCircle(
              color: Color(0xffb6b3c5),
              size: 50.0,
            ))
        ]);
  }

  Widget buildListEscuchados(list1, list2) {
    list1?.forEach(
        (element) => {cardList.add(buildCardForVerticalList(element))});

    list2?.forEach(
        (element) => {cardList.add(buildCardForVerticalList(element))});
    return ListView(
      padding: const EdgeInsets.only(top:0),
        shrinkWrap: true, controller: _scrollController, children: cardList);
    // return GridView.count(
    //     controller: _scrollController, crossAxisCount: 2, children: cardList);
  }

  Widget buildCardForVerticalList(element) {
    var site = "";
    var width = MediaQuery.of(context).size.width;
    DateTime now;
    try {
      now = DateFormat("yyyy-MM-dd'T'HH:mm:ssZ").parse(element.date);
    } catch (noDateException) {
      now = DateTime.now();
    }

    final DateFormat formatter = DateFormat('dd MMMM yyyy');
    String formatted = formatter.format(now);

    var tipo = elementFilters["contentType"];
    var messageStr = "";
    var redirectTo = "";
    if (tipo == "SERIES") {
      messageStr = "PODCAST";
      redirectTo = "/detail";
      site = "Podcast";
    } else if (tipo == "EPISODIOS") {
      messageStr = "PODCAST";
      redirectTo = "/item";
      site = "Podcast";
    } else if (tipo == "PROGRAMAS") {
      messageStr = "RADIO";
      redirectTo = "/detail";
      site = "Radio";
    } else if (tipo == "EMISIONES") {
      messageStr = "RADIO";
      redirectTo = "/item";
      site = "Radio";
    } else if (tipo == "MASESCUCHADO") {
      if (element is EpisodioModel) {
        messageStr = "PODCAST";
        redirectTo = "/item";
        site = "Podcast";
      } else if (element is EmisionModel) {
        messageStr = "RADIO";
        redirectTo = "/item";
        site = "Radio";
      }
    }

    return InkWell(
        onTap: () {
          //TODO:14/05/23 ajustar esta redirección cuando el servicio elastic se reestablezca
          Navigator.pushNamed(context, redirectTo,
              arguments: ScreenArguments("SITE", messageStr, element.uid,
                  from: "BROWSER_RESULT_PAGE"));
        },
        child: Container(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                  width: width * 0.25,
                  height: width * 0.25,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff121C4A).withOpacity(0.3),
                        spreadRadius: 3,
                        blurRadius: 10,
                        offset: const Offset(5, 5),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: element.imagen,
                      placeholder: (context, url) => const Center(
                          child: SpinKitFadingCircle(
                        color: Color(0xffb6b3c5),
                        size: 50.0,
                      )),
                      errorWidget: (context, url, error) =>
                          Image.asset("assets/images/default.png"),
                    ),
                  )),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    drawCategoryTitle(element),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        element.title,
                        maxLines: 5,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: Text(
                        site,
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(isDarkMode ? 0xFFFFFFFF : 0xff121C4A),
                            fontStyle: FontStyle.italic),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20),
                      child: drawDuration(formatted, element),
                    )
                  ]))
            ])));
  }

  Text drawDuration(String formatted, element) {
    try {
      return Text(
        "$formatted ${(element != null && element.duration != null && element.duration != "") ? formatDurationString(element.duration) : ''}",
        style: TextStyle(
            fontSize: 10, color: Color(isDarkMode ? 0xFFFFFFFF : 0xff666666)),
      );
    } catch (e) {}
    return Text('');
  }

  Container drawCategoryTitle(element) {
    try {
      if (element.categoryTitle != null && element.categoryTitle != "") {
        return Container(
          padding: const EdgeInsets.only(left: 10, right: 10),
          margin: const EdgeInsets.only(left: 20, bottom: 10),
          decoration: BoxDecoration(
            color: const Color(0xFFFCDC4D),
            boxShadow: [
              BoxShadow(
                color: Color(isDarkMode ? 0xFFFCDC4D : 0xff121C4A)
                    .withOpacity(0.3),
                spreadRadius: 3,
                blurRadius: 10,
                offset: const Offset(5, 5), // changes position of shadow
              ),
            ],
          ),
          child: Text(
            element.categoryTitle,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xff121C4A)),
          ),
        );
      }
    } catch (e) {}
    return Container(
      margin: const EdgeInsets.only(left: 20, bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.foregroundColor,
        // boxShadow: [
        //   BoxShadow(
        //     color: const Color(isDarkMode?:0xFFFCDC4D:0xff121C4A).withOpacity(0.3),
        //     spreadRadius: 3,
        //     blurRadius: 10,
        //     offset: const Offset(5, 5), // changes position of shadow
        //   ),
        // ],
      ),
      child: Text(
        '',
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
    );
  }

  String formatDurationString(String duration) {
    String formatted = "";
    if (duration != null || duration != "") {
      if (duration.substring(0, 2) == "00") {
        formatted = "| " + duration.substring(3);
      } else {
        formatted = "| " + duration;
      }
    }

    return formatted;
  }

  /*
  * Realiza la busqueda en todos los sitios
  * */
  Widget getMultiTabResult() {
    return MultiTabResult(
      tabIndex: 0,
      query: elementFilters["query"],
      page: page,
      sede: elementFilters["sede"],
      canal: elementFilters["canal"],
      area: elementFilters["area"],
      filterString: elementFilters["filterString"],
    );
  }
}
