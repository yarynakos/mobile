import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController textController = TextEditingController();
  int _counter = 0;
  bool isError = false;
  bool isLightMode = false;
  bool isFlashGreen = false;

  void _changeValue() {
    setState(() {
      isError = false;
      final enteredValue = textController.text.trim();

      if (enteredValue.isNotEmpty) {
        final parsedValue = int.tryParse(enteredValue);

        if (parsedValue != null) {
          _counter += parsedValue;
        } else if (enteredValue == 'Avada Kedavra') {
          _counter = 0;
          _flashGreenScreen();
        } else if (enteredValue == 'Lumos') {
          isLightMode = true;
        } else if (enteredValue == 'Nox') {
          isLightMode = false;
        } else {
          isError = true;
        }
      }

      textController.clear();
    });
  }

  void _flashGreenScreen() {
    setState(() {
      isFlashGreen = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        isFlashGreen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isFlashGreen
          ? Colors.greenAccent
          : isLightMode
              ? Colors.white
              : Colors.black87,
      appBar: AppBar(
        backgroundColor: isFlashGreen
            ? Colors.green
            : isLightMode
                ? Colors.yellow[700]
                : Colors.deepPurple,
        title: const Text('Magic App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: textController,
              decoration: InputDecoration(
                hintText: 'Enter value',
                fillColor: isError ? Colors.red[100] : Colors.white,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _changeValue,
              style: ElevatedButton.styleFrom(
                backgroundColor: isLightMode
                    ? Colors.yellow[700]
                    : Theme.of(context).colorScheme.primary,
              ),
              child: const Text(
                'Change Value',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: $_counter',
              style: TextStyle(
                fontSize: 24,
                color: isLightMode ? Colors.black : Colors.white,
              ),
            ),
            if (isError)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Can't convert string to number :)",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
