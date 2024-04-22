import 'package:app_moeda/cotacao_controller.dart';
import 'package:app_moeda/cotacao_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
//criar variavel e 
  late final CotacaoController ctlCotacao;

//cria a variável e instância um objeto do tipo CotacaoProvider()
  final CotacaoProvider provider = CotacaoProvider();

//cria variável e um objeto do tipo TextEditingController();
  final TextEditingController _inputText = TextEditingController();

//cria a variável e instância um objeto do tipo GlobalKey<FormState>()
  final _formState = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    ctlCotacao = CotacaoController(provider: provider, input: _inputText);
    //WidgetsBinding.instance.addPostFrameCallback((timeStamp) { }); // 
  }

  void setMsgError(String titulo, String mensagem) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: [
                Icon(
                  Icons.warning,
                  color: Colors.red,
                ),
                SizedBox(
                  width: 20,
                ),
                Text(
                  titulo,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ],
            ),
            content: Text(
              mensagem,
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: TextStyle(color: Colors.red),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
               Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        buildChoice('USD', context),
                        const SizedBox(width: 20,),
                        buildChoice('EUR', context),
                        const SizedBox(width: 20,),
                        buildChoice('BTC', context),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildText('Cotação ${ctlCotacao.moeda} -> BRL', 30),
                    Form(
                      key: _formState,
                      child: Column(
                        children: [
                          buildTextField('Valor em ${ctlCotacao.moeda}', _inputText),
                          buildButton('Execultar Cotação'),
                        ], 
                      ),
                    ),
                    AnimatedBuilder( // ele equivale um setState só que localizado //ele que recebe e faz
                      animation: ctlCotacao, 
                      builder: (context, child){
                        return buildText (
                          'Cotação ${ctlCotacao.moeda}: R\$ ${ctlCotacao.cotacaoHojeStr}', 20);
                      },
                    ),
                    const SizedBox(height: 20),
                    AnimatedBuilder(
                      animation: ctlCotacao, 
                      builder: (_, child){
                        return buildText(
                          'Em BRL (REAL): R\$ ${ctlCotacao.valorEmRealStr}', 20);
                      },
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

Widget buildTextField(String label, TextEditingController input){
  return Padding(
    padding: const EdgeInsets.only( left: 20, right: 20, top: 40, bottom: 10),
    child: TextFormField(
      controller: input,
      keyboardType: TextInputType.number,
      style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          borderSide: BorderSide(color: Colors.white),
        ),
        prefixIcon: const Icon(Icons.monetization_on),
        prefixIconColor:  Colors.white,
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder:  const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
          borderSide: BorderSide(color: Colors.white)
        ),
        focusedErrorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.yellow, width: 1),
          borderRadius: BorderRadius.all(
            Radius.circular(30.0),
          ),
        ),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white),
        helperStyle: const TextStyle(color: Colors.white),
        errorStyle:  const TextStyle(color: Colors.yellow),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Informe o valor!';
        }
        return null;
      },
    ),
  );
}

Widget buildButton(String texto){
   return Padding(
    padding: const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 30),
    child: SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: (){
          if(_formState.currentState!.validate()){   // currentState é estado atual do formulário
            ctlCotacao.getCotacao();  // está vindo tudo do controller
          }
        }, 
        icon: const Icon(Icons.check),
        label: Text(
          texto,
          style: const TextStyle(fontSize: 15),
        ),
      ),
    ),
   );
}

Widget buildText(String texto, double size){
  return Text(
    texto,
    style: TextStyle(
      color: Colors.white,
      fontSize: size,
    ),
  );
}

  Widget buildChoice(String label, BuildContext context) {  //Função retornando um Widget
    return ChoiceChip(   
      checkmarkColor: Colors.white,
      label: Text(label),
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Colors.white
      ),
      selected: (label == ctlCotacao.moeda),
      selectedColor: Colors.green,
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      onSelected: (value) {
        setState(() {
            ctlCotacao.moeda = label;
        });
      },
    );
  }
}

