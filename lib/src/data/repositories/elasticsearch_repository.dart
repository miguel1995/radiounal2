import 'package:connectivity_plus/connectivity_plus.dart';

import '../providers/elasticsearch_provider.dart';

class ElasticSearchRepository {
  final elasticSearchProvider = ElasticSearchProvider();

  Future<Map<String, dynamic>> findSearch(
      String query,
      int from,
      int size
      ) async {

    var connectivityResult = await (Connectivity().checkConnectivity());
    Map<String, dynamic> temp = {};

    if (connectivityResult == ConnectivityResult.wifi ||
        connectivityResult == ConnectivityResult.mobile) {

      // Si hay conexion por wifi o Si hay conexion por datos
      temp = await elasticSearchProvider.getSearch(
        query,
        from,
        size
      );

    }

    return temp;
  }
}
