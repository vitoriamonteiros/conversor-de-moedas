import 'package:flutter/material.dart';
import 'cotacao_provider.dart';

class CotacaoController extends ChangeNotifier {
  final TextEditingController input;
  final CotacaoProvider provider;
  double _valorEmReal = 0;
  double _cotacaoHoje = 0;
  String _moeda = 'USD';

  CotacaoController({required this.provider, required this.input}); // Obrigado a passar esses dois argumentos provider e input

  double get valorEmReal => _valorEmReal;
  double get cotacaoHoje => _cotacaoHoje;
  String get moeda => _moeda;

  String get valorEmRealStr => _valorEmReal.toStringAsFixed(4);
  String get cotacaoHojeStr => _cotacaoHoje.toStringAsFixed(4);

  set moeda(String value) {
    _moeda = value;
      _valorEmReal = 0;
      _cotacaoHoje = 0;
      notifyListeners();
  }

  set cotacao (double value) {
    _cotacaoHoje = value;
    _valorEmReal = (_cotacaoHoje * (double.tryParse(input.text) ?? 0));
    notifyListeners(); // Herdado do ChangeNotifier, NotifyListeners não atualiza tela mas sim informa que existe modificações.
  }

  void getCotacao() async {
    var valor = await provider.getCotacaoApi(
      'https://economia.awesomeapi.com.br/json/last/$moeda-BRL', moeda);
    
    cotacao = double.tryParse(valor!) ?? 0; // Se der um erro\nulo ele retorna 0 (?? = ou) 
  }
}