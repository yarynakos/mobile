import 'package:flutter/material.dart';
import 'package:my_project/data/local_user_repository.dart';
import 'package:my_project/screen/view_last_message.dart';
import 'package:my_project/screen/qr_scanner_screen.dart';
import 'package:my_project/service/mqtt_service.dart';
import 'package:my_project/widgets/custom_button.dart';

class Plant {
  final String name;
  int? moisture;

  Plant({required this.name, this.moisture});

  String get status {
    if (moisture == null) return 'Loading...';
    if (moisture! < 40) return 'Needs Water';
    if (moisture! < 60) return 'Healthy';
    return 'Thriving';
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _userEmail;

  final _userRepository = LocalUserRepository();
  final List<Plant> _plants = [
    Plant(name: 'aloe_vera'),
    Plant(name: 'ficus'),
    Plant(name: 'snake_plant'),
    Plant(name: 'peace_lily'),
  ];

  final List<MqttService> _mqttServices = [];

  @override
  void initState() {
    super.initState();
    _loadUser();
    _connectToMqtt();
  }

  Future<void> _loadUser() async {
    final user = await _userRepository.getUser();
    if (mounted) {
      setState(() {
        _userEmail = user?.email;
      });
    }
  }

  void _connectToMqtt() {
    for (final plant in _plants) {
      final currentPlant = plant;

      final service = MqttService(
        topic: 'sensor/soil/${currentPlant.name}',
        onMessage: (payload) {
          final value = int.tryParse(payload);
          if (value != null) {
            setState(() {
              currentPlant.moisture = value;
            });
          }
        },
      );

      _mqttServices.add(service);
      service.connect();
    }
  }

  @override
  void dispose() {
    for (final service in _mqttServices) {
      service.disconnect();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isWideScreen = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(_userEmail != null ? 'Welcome, $_userEmail' : 'Plant Care'),
        backgroundColor: const Color(0xFF73E9EB),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 10),
            const Text(
              'Your Plants',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Expanded(
              child: GridView.count(
                crossAxisCount: isWideScreen ? 2 : 1,
                childAspectRatio: isWideScreen ? 3 : 2.5,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children:
                    _plants.map((plant) {
                      return PlantCard(
                        name: _capitalize(plant.name.replaceAll('_', ' ')),
                        status:
                            '${plant.status} (${plant.moisture?.toString() ?? "--"}%)',
                      );
                    }).toList(),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Open Camera',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<QRScannerScreen>(
                          builder: (context) => const QRScannerScreen(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: CustomButton(
                    text: 'View Last Message',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute<MessageScreen>(
                          builder: (context) => const MessageScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            CustomButton(
              text: 'Go to Profile',
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
          ],
        ),
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

class PlantCard extends StatelessWidget {
  final String name;
  final String status;

  const PlantCard({required this.name, required this.status, super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(status),
      ),
    );
  }
}
