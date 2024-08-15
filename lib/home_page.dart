import 'dart:developer';

import 'package:flutter/material.dart';

import 'helpers/pix.dart';
import 'helpers/system.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final copy = TextEditingController();
  final past = TextEditingController();
  String? receiverName;

  void _showAlertDialog(String clipboard) {
    if (Pix.isValidCopyPastPIXCode(clipboard)) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Bem-vindo de volta!'),
            content: const Text('O aplicativo voltou do background.'),
            actions: [
              TextButton(
                onPressed: () async {
                  final textToPast = await System.pasteFromClipboard();
                  setState(() {
                    past.text = textToPast;
                  });
                  log('Texto colado: ${past.text})');
                  if (!context.mounted) return;
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // O aplicativo voltou do background
      log("App voltou do background");

      final clipboard = await System.startClipboardMonitor();
      _showAlertDialog(clipboard);
    } else if (state == AppLifecycleState.paused) {
      // O aplicativo foi para o background
      log("App foi para o background");
    } else if (state == AppLifecycleState.inactive) {
      // O aplicativo foi para o background
      log("App foi para o inactive");
    } else if (state == AppLifecycleState.detached) {
      // O aplicativo foi para o background
      log("App foi para o detached");
    } else if (state == AppLifecycleState.hidden) {
      // O aplicativo foi para o background
      log("App foi para o background");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 40),
          const Text('Text to copy'),
          TextFormField(
            controller: copy,
          ),
          const SizedBox(height: 40),
          const Text('Box to past'),
          TextFormField(
            controller: past,
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Copia'),
            onPressed: () {
              if (Pix.isValidCopyPastPIXCode(copy.text)) {
                System.copyToClipboard(copy.text);
                log('Texto copiado: ${copy.text}');
              } else {
                log('código inválido');
              }
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text('Cola'),
            onPressed: () async {
              if (Pix.isValidCopyPastPIXCode(copy.text)) {
                final textToPast = await System.pasteFromClipboard();
                setState(() {
                  past.text = textToPast;
                });
                log('Texto colado: ${past.text})');
              }
            },
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            child: const Text('getReceiverName'),
            onPressed: () async {
              setState(() {
                receiverName = Pix.getReceiverName(past.text);
              });
            },
          ),
          const SizedBox(height: 40),
          if (receiverName != null) Text(receiverName!),
        ],
      ),
    );
  }
}
