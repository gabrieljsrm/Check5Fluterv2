import 'package:flutter/material.dart';

class ConversaoPage extends StatefulWidget {
  const ConversaoPage({Key? key}) : super(key: key);

  @override
  _ConversaoPageState createState() => _ConversaoPageState();
}

class _ConversaoPageState extends State<ConversaoPage> {
  final TextEditingController valorRealController = TextEditingController();
  double valorConvertido = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversão de Moeda'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: valorRealController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Valor em Real'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    final double valorReal =
                        double.tryParse(valorRealController.text) ?? 0.0;
                    final double taxaCambio = 5.2; // Defina a taxa de câmbio desejada
                    valorConvertido = valorReal * taxaCambio;
                  });
                },
                child: const Text('Converter'),
              ),
              const SizedBox(height: 16.0),
              Text('Valor em Dólar: \$${valorConvertido.toStringAsFixed(2)}'),
            ],
          ),
        ),
      ),
    );
  }
}
