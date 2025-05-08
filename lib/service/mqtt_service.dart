import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

typedef MqttMessageCallback = void Function(String payload);

class MqttService {
  final String topic;
  final MqttMessageCallback onMessage;
  late MqttServerClient client;

  MqttService({required this.topic, required this.onMessage}) {
    client = MqttServerClient('broker.hivemq.com', '');
    client.logging(on: false);
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  Future<void> connect() async {
    final connMess = MqttConnectMessage()
        .withClientIdentifier(
      'flutter_client_${DateTime.now().millisecondsSinceEpoch}',
    )
        .startClean();
    client.connectionMessage = connMess;

    try {
      await client.connect();
    } catch (e) {
      debugPrint('MQTT connection error: $e');
      client.disconnect();
      return;
    }

    client.subscribe(topic, MqttQos.atMostOnce);
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      final recMess = events[0].payload as MqttPublishMessage;
      final message = String.fromCharCodes(recMess.payload.message);
      onMessage(message);
    });
  }

  void disconnect() => client.disconnect();

  void _onDisconnected() => debugPrint('Disconnected from $topic');

  void _onConnected() => debugPrint('Connected to $topic');

  void _onSubscribed(String topic) => debugPrint('Subscribed to $topic');
}
