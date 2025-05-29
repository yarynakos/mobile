import 'dart:typed_data';

import 'package:my_project/models/device_credentials.dart';
import 'package:usb_serial/usb_serial.dart';

class UartService {
  UsbPort? _port;

  Future<bool> connect() async {
    final devices = await UsbSerial.listDevices();
    if (devices.isEmpty) return false;
    _port = await devices.first.create();
    return await _port!.open();
  }

  Future<void> sendCredentials(DeviceCredentials creds) async {
    if (_port == null) return;
    final payload = creds.toSaveCommand();
    await _port!.write(Uint8List.fromList(payload.codeUnits));
  }

  Future<DeviceCredentials?> readFromDevice() async {
    if (_port == null) return null;
    await _port!.write(Uint8List.fromList('READ\n'.codeUnits));

    final data = await _port!.inputStream?.first;
    if (data != null) {
      final raw = String.fromCharCodes(data);
      return DeviceCredentials.fromRaw(raw);
    }
    return null;
  }

  Future<String> readResponse() async {
    if (_port == null) return 'ERROR';
    final data = await _port!.inputStream?.first;
    return data != null ? String.fromCharCodes(data) : 'ERROR';
  }

  void close() {
    _port?.close();
  }
}
