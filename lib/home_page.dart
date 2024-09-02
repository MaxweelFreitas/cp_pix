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
    final pixKeyType = Pix.getPixKeyType(clipboard);

    if (pixKeyType == PixKeyType.invalid) return;

    // Mapeia tipos de chave Pix para seus títulos, textos e funções associadas
    final Map<PixKeyType, Map<String, dynamic>> dialogData = {
      PixKeyType.cpf: {
        'title': 'CPF copiado',
        'text': 'Deseja fazer um PIX com o CPF?',
        'function': () {
          log('Fazendo PIX com CPF: $clipboard');
          // Adicione aqui a lógica específica para CPF
        },
      },
      PixKeyType.cnpj: {
        'title': 'CNPJ copiado',
        'text': 'Deseja fazer um PIX com o CNPJ?',
        'function': () {
          log('Fazendo PIX com CNPJ: $clipboard');
          // Adicione aqui a lógica específica para CNPJ
        },
      },
      PixKeyType.phone: {
        'title': 'Phone copiado',
        'text': 'Deseja fazer um PIX com o Phone?',
        'function': () {
          log('Fazendo PIX com Phone: $clipboard');
          // Adicione aqui a lógica específica para Phone
        },
      },
      PixKeyType.email: {
        'title': 'Email copiado',
        'text': 'Deseja fazer um PIX com o Email?',
        'function': () {
          log('Fazendo PIX com Email: $clipboard');
          // Adicione aqui a lógica específica para Email
        },
      },
      PixKeyType.copyPast: {
        'title': 'CPPIx copiado',
        'text': 'Deseja fazer um PIX com o CPPIx?',
        'function': () {
          log('Fazendo PIX com CPPIx: $clipboard');
          // Adicione aqui a lógica específica para CPPIx
        },
      },
      PixKeyType.random: {
        'title': 'RandomicKey copiado',
        'text': 'Deseja fazer um PIX com o RandomicKey?',
        'function': () {
          log('Fazendo PIX com RandomicKey: $clipboard');
          // Adicione aqui a lógica específica para RandomicKey
        },
      },
    };

    final data = dialogData[pixKeyType]!;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(data['title']!),
          content: Text(data['text']!),
          actions: [
            TextButton(
              onPressed: () async {
                if (!mounted) return;
                await Future.microtask(
                    () => data['function']()); // Executa a função específica
                setState(() {
                  receiverName = clipboard;
                });
                if (mounted) Navigator.of(context).pop();
              },
              child: const Text('Sim'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
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
              if (Pix.isValidCopyPast(copy.text)) {
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
              if (Pix.isValidCopyPast(copy.text)) {
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
