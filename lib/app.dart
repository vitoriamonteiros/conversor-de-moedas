import 'package:app_moeda/cotacao_page.dart';
import 'package:flutter/material.dart';


class AppCotacaoRefactor extends StatelessWidget {
  const AppCotacaoRefactor({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cotação',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true, //use o material
      ),
      home: const MyHomePage(),
    );
  }
}

