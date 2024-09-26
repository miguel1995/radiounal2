import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:radiounal2/src/business_logic/firebase/firebaseLogic.dart';
//import 'package:platform_device_id_v3/platform_device_id.dart';
import 'package:radiounal2/src/business_logic/DeviceInfoUtils.dart';

import 'package:radiounal2/src/presentation/partials/confirm_dialog.dart';

import '../../business_logic/bloc/favorito_bloc.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class FavoritoBtn extends StatefulWidget {
  final int uid; //Indica el id del episodio de podcast o emisora de radio
  final String message;
  final String tipo;
  final bool isPrimaryColor;

  const FavoritoBtn(
      {Key? key,
      required this.uid,
      required this.message,
      required this.tipo,
      required this.isPrimaryColor})
      : super(key: key);

  @override
  State<FavoritoBtn> createState() => _FavoritoBtnState();
}

class _FavoritoBtnState extends State<FavoritoBtn> {
  bool _isFavorito = false;
  String? _deviceId;
  late FirebaseLogic firebaseLogic;
  late int uid; //Indica el id del episodio de podcast o emisora de radio
  late String message;
  late String tipo;
  late bool isPrimaryColor;

  FavoritoBloc blocFavorito = FavoritoBloc();
 bool isDarkMode =false;

  @override
  void initState() { 
    var brightness = SchedulerBinding.instance.window.platformBrightness;
 isDarkMode = brightness == Brightness.dark;
    uid = widget.uid;
    message = widget.message;
    tipo = widget.tipo;
    isPrimaryColor = widget.isPrimaryColor;

    firebaseLogic = FirebaseLogic();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String? deviceId;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      //deviceId = await PlatformDeviceId.getDeviceId;
      var deviceInfoUtils = DeviceInfoUtils();
      await deviceInfoUtils.getDeviceDetails().then((value) => deviceId=value);
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
    });

    blocFavorito.validateFavorite(uid, _deviceId, tipo);
    blocFavorito.subject.stream.listen((event) {
      setState(() => {_isFavorito = event});
    });
  }

  Future<AdaptiveThemeMode?> themeMethod() async {
    final savedThemeMode = await AdaptiveTheme.getThemeMode();
    return savedThemeMode;
  }

  @override
  Widget build(BuildContext context) {

    themeMethod().then((value) {
      setState(() {
        isDarkMode = (value == AdaptiveThemeMode.dark);
      });
    });

    return InkWell(
        onTap: () {
          if (_isFavorito == true) {
            firebaseLogic.eliminarFavorite(uid, _deviceId).then((value) => {
                  setState(() {
                    _isFavorito = false;
                  })
                });
          } else {
            setState(() {
              _isFavorito = true;
            });
            firebaseLogic
                .agregarFavorito(uid, message,
                    tipo, _deviceId)
                .then((value) => {
                      if (value != true)
                        {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Se ha presentado un problema, intentelo más tarde")))
                        }

                    });
          }
        },
        child: Container(
            padding: const EdgeInsets.only(left: 3, right: 3),
            child: (_isFavorito == true)
                ? SvgPicture.asset(
                    'assets/icons/icono_corazon_completo.svg',
                    color: (isPrimaryColor)
                        ? isDarkMode ? const Color(0xFFFCDC4D):const Color(0xFF121C4A)
                        : isDarkMode ? const Color(0xFF121C4A):const Color(0xFFFCDC4D)
                  )
                : SvgPicture.asset(
                    'assets/icons/icono_corazon_borde.svg',
                    color: (isPrimaryColor)
                        ? isDarkMode ? const Color(0xFFFCDC4D):const Color(0xFF121C4A)
                        : isDarkMode ? const Color(0xFF121C4A):const Color(0xFFFCDC4D)
                  )));
  }

}
