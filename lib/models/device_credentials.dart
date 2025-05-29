class DeviceCredentials {
  final String uid;
  final double humidityDivider;
  final String login;
  final String password;
  final bool useEEPROM;

  DeviceCredentials({
    required this.uid,
    required this.humidityDivider,
    required this.login,
    required this.password,
    required this.useEEPROM,
  });

  factory DeviceCredentials.fromQr(String qrData) {
    final parts = qrData.split(';');
    if (parts.length != 4) throw const FormatException('Invalid QR data');
    return DeviceCredentials(
      uid: parts[0],
      humidityDivider: double.tryParse(parts[1]) ?? 1.0,
      login: parts[2],
      password: parts[3],
      useEEPROM: true,
    );
  }

  factory DeviceCredentials.fromRaw(String rawData) {
    final parts = rawData.trim().split(';');
    if (parts.length != 5) throw const FormatException('Invalid device data');
    return DeviceCredentials(
      uid: parts[0],
      humidityDivider: double.tryParse(parts[1]) ?? 1.0,
      login: parts[2],
      password: parts[3],
      useEEPROM: parts[4] == '1',
    );
  }

  String toSaveCommand() {
    return 'SAVE;$uid;$humidityDivider;$login;$password;${useEEPROM ? '1' : '0'}\\n';
  }
}
