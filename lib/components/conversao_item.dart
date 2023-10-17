import 'package:flutter/material.dart';

class ConversaoItem extends StatelessWidget {
  final String moedaOrigem;
  final String moedaDestino;
  final double valorOrigem;
  final double valorDestino;

  const ConversaoItem({ Key? key,
    required this.moedaOrigem,
    required this.moedaDestino,
    required this.valorOrigem,
    required this.valorDestino, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Text(moedaOrigem),
      title: Text('Conversão do valor em $moedaOrigem para $moedaDestino'),
      subtitle: Text('Valor original: $valorOrigem\n Valor convertido: $valorDestino')
    );
  }
}
