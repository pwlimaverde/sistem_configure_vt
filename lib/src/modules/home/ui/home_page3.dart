import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class HomePage3 extends StatefulWidget {
  const HomePage3({super.key});

  @override
  State<HomePage3> createState() => _HomePage3State();
}

class _HomePage3State extends State<HomePage3> {
  String text = 'stop service';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teste service'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke('setAsForeground');
                },
                child: const Text('Foreground Service')),
            ElevatedButton(
                onPressed: () {
                  FlutterBackgroundService().invoke('setAsBackground');
                },
                child: const Text('Background Service')),
            ElevatedButton(
                onPressed: () async {
                  final service = FlutterBackgroundService();
                  bool isRunning = await service.isRunning();
                  if (isRunning) {
                    FlutterBackgroundService().invoke('stopService');
                  } else {
                    service.startService();
                  }
                  if (!isRunning) {
                    text = 'Stop Service';
                  } else {
                    text = 'Start Service';
                  }
                  setState(() {});
                },
                child: Text(text)),
          ],
        ),
      ),
    );
  }
}
