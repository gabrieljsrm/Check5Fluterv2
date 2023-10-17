import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class ConversaoPage extends StatefulWidget {
  const ConversaoPage({Key? key}) : super(key: key);

  @override
  _ConversaoPageState createState() => _ConversaoPageState();
}

class _ConversaoPageState extends State<ConversaoPage> {
  final TextEditingController valorRealController = TextEditingController();
  final TextEditingController adicionarSaldoController = TextEditingController();
  double valorConvertido = 0.0;
  double taxaCambio = 0.0;

  double saldoReal = 0.0;
  double saldoDolar = 0.0;

  Future<void> obterTaxaCambio() async {
    const url = 'https://economia.awesomeapi.com.br/json/last/USD-BRL';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        taxaCambio = double.parse(data['USDBRL']['bid']);
      });
    } else {
      print('Falha ao obter a taxa de câmbio.');
    }
  }

  Future<void> fetchSaldos() async {
    Supabase.instance.client.from('saldos').select().execute().then((response) {
      if (response.data != null && response.data!.isNotEmpty) {
        final data = response.data as List;
        setState(() {
          saldoReal = data[0]['saldo_real'].toDouble();
          saldoDolar = data[0]['saldo_dolar'].toDouble();
        });
      } else {
        print('Erro ao buscar saldos.');
      }
    }).catchError((error) {
      print('Erro ao buscar saldos: $error');
    });
  }

  Future<void> updateSaldos() async {
    Supabase.instance.client.from('saldos')
        .update({
          'saldo_real': saldoReal,
          'saldo_dolar': saldoDolar,
          'valor_dolar_usado': taxaCambio,
        })
        .eq('id', 1)
        .execute()
        .then((response) {
      if (response.data == null) {
        print('Erro ao atualizar saldos.');
      }
    }).catchError((error) {
      print('Erro ao atualizar saldos: $error');
    });
  }

  Future<void> adicionarSaldo() async {
    final double? valorAdicionado =
        double.tryParse(adicionarSaldoController.text);

    if (valorAdicionado != null && valorAdicionado > 0) {
      setState(() {
        saldoReal += valorAdicionado;
      });

      await updateSaldos();
      fetchSaldos();
      adicionarSaldoController.clear();
    } else {
      print('Por favor, insira um valor válido para adicionar ao saldo.');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSaldos();
    obterTaxaCambio();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversão de Moeda'),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              fetchSaldos();
              obterTaxaCambio();
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Saldo em R\$ ${saldoReal.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                  Text(
                    'Saldo em \$ ${saldoDolar.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.teal),
                  ),
                ],
              ),
              const Divider(color: Colors.teal, thickness: 2),
              const SizedBox(height: 16.0),
              TextField(
                controller: adicionarSaldoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Adicionar Saldo em Real',
                  prefixIcon: Icon(Icons.add, color: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () => adicionarSaldo(),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                child: const Text('Adicionar Saldo'),
              ),
              const SizedBox(height: 16.0),
              TextField(
                controller: valorRealController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Valor em Real para Conversão',
                  prefixIcon: Icon(Icons.money, color: Colors.teal),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.teal),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: taxaCambio > 0 ? () {
                  setState(() {
                    final double? valorReal =
                        double.tryParse(valorRealController.text);

                    if (valorReal == null || valorReal <= 0) {
                      print('Por favor, insira um valor válido!');
                      valorConvertido = 0.0;
                      return;
                    }

                    valorConvertido = valorReal / taxaCambio;
                    saldoReal -= valorReal;
                    saldoDolar += valorConvertido;

                    updateSaldos();
                  });
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Converter'),
              ),
              const SizedBox(height: 16.0),
              Text(
                'Valor em Dólar: \$${valorConvertido.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 20, color: Colors.teal),
              ),
              const SizedBox(height: 16.0),
              taxaCambio > 0
                  ? Text(
                      'Taxa de Câmbio Atual: R\$${taxaCambio.toStringAsFixed(2)}',
                      style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                    )
                  : const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
