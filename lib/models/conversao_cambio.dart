class ConversaoCambio {

  double valorReal;
  double valorDolar;
  double taxaCambio = 5.2;
  double valorConvertido;

  ConversaoCambio({
    required this.valorReal,
    required this.valorDolar,
    required this.taxaCambio,
    required this.valorConvertido

  }) {
    valorConvertido = valorReal * taxaCambio;
  }
  
}

//class ConversaoCambio {
  //final String moedaOrigem;
  //final String moedaDestino;
  //final double valorOrigem;
  //final double taxaCambio;
  //double valorConvertido;

  //ConversaoCambio({
    //required this.moedaOrigem,
    //required this.moedaDestino,
    //required this.valorOrigem,
    //required this.taxaCambio,
  //}) {
    //valorConvertido = valorOrigem * taxaCambio;
  //}}



