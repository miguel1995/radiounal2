import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:radiounal2/src/presentation/partials/app_bar_radio.dart';
import 'package:radiounal2/src/presentation/partials/menu.dart';
import 'package:url_launcher/url_launcher.dart';

class PoliticsPage extends StatefulWidget {
  const PoliticsPage({Key? key}) : super(key: key);

  @override
  State<PoliticsPage> createState() => _PoliticsPageState();
}

class _PoliticsPageState extends State<PoliticsPage> {
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
  }

  @override
  Widget build(BuildContext context) {
    themeMethod().then((value) {
      setState(() {
        isDarkMode = value == AdaptiveThemeMode.dark;
      });
    });

    return Scaffold(
        backgroundColor: isDarkMode ? const Color(0xFF121C4A) : const Color(0xFFFFFFFF),
        extendBodyBehindAppBar: true,
        endDrawer: const Menu(),
        appBar: AppBarRadio(enableBack: true),
        body: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.001),
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: SingleChildScrollView(
              child: Container(
            //color: Colors.red,
            padding: const EdgeInsets.only(
                left: 25, right: 25, top: 100, bottom: 25),

            child: Column(
              children: <Widget>[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      "Políticas de privacidad",
                      style: TextStyle(
                        shadows: [
                          Shadow(
                              color: Theme.of(context).primaryColor,
                              offset: const Offset(0, -5))
                        ],
                        color: Colors.transparent,
                        decorationThickness: 2,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        decorationColor:
                            Color(isDarkMode ? 0xff121C4A : 0xFFFCDC4D),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ),
                 Text(
                    'RadioUNAL usa información almacenada en el dispositivo donde se encuentra instalada. Esta información consiste en:\n',
                  style: TextStyle(
                    color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                  )
                ),
                Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Estado del dispositivo: activo, inactivo.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Estado de conexión a internet, puede usar datos del dispositivo.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Registro de la consulta de contenidos a través de la aplicación.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Tokens (identificadores generados para la aplicación móvil, que no corresponden al ID de cada dispositivo) para la funcionalidad de notificaciones.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Preferencias de los usuarios acerca de los eventos (para notificaciones).',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                    ])),
                 Text(
                    '\nEsta información es recopilada en la plataforma Firebase, siguiendo los términos de servicio de las API de Google.',
                    style: TextStyle(
                      color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                    )
                ),
                Text(
                    '\nEsta información es usada con los siguientes fines:\n',
                    style: TextStyle(
                      color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Advertir sobre nuevos contenidos o posibles cambios en los mismos.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Llevar estadísticas de los contenidos vistos a través de la aplicación.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Ofrecer un servicio de notificaciones con base en las preferencias del usuario.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                    ])),
                Text(
                    '\nParte de la información almacenada en Firebase podría usarse en el futuro con fines estadísticos sobre el uso de la aplicación.',
                    style: TextStyle(
                      color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                    )
                ),
                Text(
                    '\nPor otro lado los datos personales que recopilamos son los solicitados en los formularios de descarga de contenido y contacto y serán tratados y resguardados con base en los principios establecidos en la legislación aplicable (Resolución 207 DE 2021 (16 de abril) "Por la cual se establece la Política de Tratamiento de Datos Personales de la Universidad Nacional de Colombia y se derógala Resolución No. 440 de 2019 de Rectoría"). Los datos solicitados son los siguientes: Nombres y Apellidos, Correo Electrónico, Número de Contacto, Edad, País, Ciudad y datos sensibles como Género.',
                    style: TextStyle(
                      color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                    )
                ),
                 Text(
                    '\nEsta información se guarda en bases de datos almacenados en servidores internos de la Universidad y son cifrados en tránsito para más seguridad.',
                    style: TextStyle(
                      color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                    )
                ),
                Text(
                    '\n Estos serán utilizados para los siguientes fines:',
                    style: TextStyle(
                      color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                    )
                ),
                Container(
                    margin: EdgeInsets.only(left: 20.0),
                    child: Column(children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Obtener canales de comunicación con el usuario (datos de contacto) para dar respuesta a las solicitudes por el formulario de contáctenos.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:  <Widget>[
                          Text("• ",
                              style: TextStyle(
                                color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                              )
                          ),
                          Expanded(
                            child: Text(
                                'Registrar las descargas que se realicen de los contenidos disponibles con esta opción.',
                                style: TextStyle(
                                  color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                                )
                            ),
                          ),
                        ],
                      )
                    ])),
                 Text(
                    '\nEn ningún caso se usará la información recopilada con fines comerciales que puedan beneficiar a terceros; tampoco se entregará a personas o entidades externas a la Universidad Nacional de Colombia.',
                     style: TextStyle(
                       color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                     )
                 ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                    child: Text(
                      'Propiedad intelectual',
                      style: TextStyle(
                          color: isDarkMode
                              ? Colors.white
                              : Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontFamily: 'AncizarSans',
                      color: isDarkMode
                          ? Colors.white
                          : Theme.of(context).primaryColor,
                    ),
                    children: const <TextSpan>[
                      TextSpan(
                          text:
                              'Los contenidos (imágenes, textos y videos) provistos a través de '),
                      TextSpan(
                          text: 'RadioUNAL',
                          style: TextStyle(fontStyle: FontStyle.italic)),
                      TextSpan(
                          text:
                              'pertenecen a la Universidad Nacional de Colombia, de conformidad con el Acuerdo 035 de 2003 del Consejo Académico, “Por el cual se expide el reglamento sobre Propiedad Intelectual en la Universidad Nacional de Colombia”'),
                    ],
                  ),
                ),
                Divider(
                  color: isDarkMode
                      ? Colors.white
                      : Theme.of(context).primaryColor,
                ),
                Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Director Nacional de Unimedios: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              const TextSpan(
                                  text: 'Fredy Fernando Chaparro Sanabria'),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      'Diseño, desarrollo, implementación y normativa para web: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              TextSpan(
                                  text:
                                      'Oficina de Medios Digitales - Unimedios',
                                  style: TextStyle(
                                      color: isDarkMode
                                          ? Colors.white
                                          : Theme.of(context).primaryColor)),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                      'Dirección de la Oficina de Medios Digitales: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              TextSpan(
                                  text: 'Martha Lucía Chaves Muñoz',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Ingeniero de desarrollo: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              TextSpan(
                                  text: 'Miguel Andrés Torres Chavarro',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Apoyo en desarrollo: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              TextSpan(
                                  text: 'Giovanni Romero Pérez',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Diseño gráfico: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              TextSpan(
                                  text: 'María Teresa Naranjo Castillo',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        )),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text("• "),
                        Expanded(
                            child: RichText(
                          text: TextSpan(
                            style: TextStyle(
                              fontFamily: 'AncizarSans',
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).primaryColor,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                  text: 'Webmaster: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                              TextSpan(
                                  text:
                                      'Francisco Javier Morales  Ducuara, Aldemar Hernandez Torres',
                                  style: TextStyle(
                                    color: isDarkMode
                                        ? Colors.white
                                        : Theme.of(context).primaryColor,
                                  )),
                            ],
                          ),
                        )),
                      ],
                    ),
                  ]),
                ),
                 Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text('\nPublicado por la Oficina de Medios Digitales',
                            style: TextStyle(
                              color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                            )
                        )),
                 Align(
                    alignment: Alignment.centerLeft,
                    child:
                        Text('\nUnidad de Medios de Comunicación – Unimedios',
                            style: TextStyle(
                              color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                            )
                        )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: InkWell(
                        onTap: () async {
                          //launch('mailto:mediosdigitales@unal.edu.co');
                          String email = Uri.encodeComponent(
                              "mediosdigitales@unal.edu.co");

                          Uri mail = Uri.parse("mailto:$email");
                          if (await launchUrl(mail)) {
                            //email app opened
                          } else {
                            //email app is not opened
                          }
                        },
                        child: Text(
                          '\nmediosdigitales@unal.edu.co',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.underline,
                          ),
                        ))),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nPBX: (1) 316 5000 ext. 18280-18120',
                        style: TextStyle(
                          color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                        )
                    )),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text('\nUniversidad Nacional de Colombia',
                        style: TextStyle(
                          color: isDarkMode ?  const Color(0xFFFFFFFF):const Color(0xFF121C4A),
                        )
                    )),
              ],
            ),
          )),
        ));
  }
}
