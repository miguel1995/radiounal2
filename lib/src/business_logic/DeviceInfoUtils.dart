
import 'dart:io' show Platform;
import 'package:device_info_plus/device_info_plus.dart';
class DeviceInfoUtils {



  Future<String?> getDeviceDetails() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      print('Device ID: ${iosInfo.identifierForVendor}');
      return iosInfo.identifierForVendor;
    } else if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      print('Device ID: ${androidInfo.id}');
      return androidInfo.id;

    }
  }
}


