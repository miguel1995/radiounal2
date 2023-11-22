import 'package:radiounal2/src/data/models/emision_model.dart';
import 'package:radiounal2/src/data/models/programacion_model.dart';
import 'package:radiounal2/src/data/providers/radio_provider.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class RadioRepository {
  final radioProvider = RadioProvider();

  Future<List<EmisionModel>> findDestacados() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EmisionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.getDestacados();

    }

    return temp;
  }

  Future<List<EmisionModel>> findMasEscuchados() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EmisionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getMasEscuchados();

    }

    return temp;
  }

  Future<List<ProgramacionModel>> findProgramacion() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    List<ProgramacionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getProgramacion();

    }

    return temp;
  }

  Future<Map<String, dynamic>> findProgramas(int page) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getProgramas(page);

    }

    return temp;
  }


  Future<Map<String, dynamic>> findEmisiones(int uid, int page) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getEmisiones(uid, page);

    }

    return temp;
  }

  Future<List<EmisionModel>> findEmision(int uid) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    List<EmisionModel> temp = [];

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.getEmision(uid);

    }

    return temp;
  }


  Future<Map<String, dynamic>> findProgramasYEmisiones(List<int> programasUidList, List<int> emisionesUidList) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.getProgramasYEmisiones(programasUidList, emisionesUidList);

    }

    return temp;
  }


  Future<String> createEmail(String nombre, String email, String telefono, String mensaje) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    String temp = "";

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.postEmail(nombre, email, telefono, mensaje);

    }

    return temp;
  }

  Future<String> createEstadistica(int itemUid, String nombre, String sitio, String tipo, int score, String date) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    String temp = "";

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.postEstadistica(itemUid, nombre, sitio, tipo, score, date );

    }

    return temp;
  }

  Future<String> createDescarga(String nombre, String edad, String genero, String pais, String departamento, String ciudad, String email) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    String temp = "";

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.postDescarga(nombre, edad, genero, pais, departamento, ciudad, email);

    }

    return temp;
  }

  Future<Map<String, dynamic>> findSedes() async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos

      temp = await radioProvider.getSedes();

    }

    return temp;
  }

  Future<Map<String, dynamic>> findSearch(
      String query,
      int page,
      int sede,
      String canal,
      String area,
      String contentType
      ) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await radioProvider.getSearch(
          query,
          page,
          sede,
          canal,
          area,
          contentType
      );

    }

    return temp;
  }
}
