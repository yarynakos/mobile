import 'package:my_project/models/device_credentials.dart';

class QrParser {
  static DeviceCredentials parse(String qrData) {
    return DeviceCredentials.fromQr(qrData);
  }
}
