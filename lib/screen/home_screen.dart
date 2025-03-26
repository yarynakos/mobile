import 'package:flutter/material.dart';
import 'package:my_project/widgets/custom_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plant Care'),
        backgroundColor: const Color(0xFF73E9EB),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final bool isWideScreen = constraints.maxWidth > 600;
          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
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
                    children: const [
                      PlantCard(name: 'Aloe Vera', status: 'Needs Water'),
                      PlantCard(name: 'Ficus', status: 'Healthy'),
                      PlantCard(name: 'Snake Plant', status: 'Needs Water'),
                      PlantCard(name: 'Peace Lily', status: 'Thriving'),
                    ],
                  ),
                ),
                CustomButton(
                  text: 'Go to Profile',
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
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
