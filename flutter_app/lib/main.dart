import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TextEditingController _preco1Controller = TextEditingController();
  final TextEditingController _quantidadeMlController = TextEditingController();
  final TextEditingController _preco2Controller = TextEditingController();
  final TextEditingController _quantidadeLController = TextEditingController();
  String resultado = '';
  double diferenca = 0;

  void calcularPrecoLitro() {
    String preco1Texto = _preco1Controller.text;
    String qtdMlTexto = _quantidadeMlController.text;
    String preco2Texto = _preco2Controller.text;
    String qtdLTexto = _quantidadeLController.text;

    if (preco1Texto.isEmpty ||
        qtdMlTexto.isEmpty ||
        preco2Texto.isEmpty ||
        qtdLTexto.isEmpty) {
      setState(() {
        resultado = 'Preencha os campos';
      });
    }

    double? preco1 = double.tryParse(preco1Texto.replaceAll(",", ".")) ?? 0;
    double? qtdMl = double.tryParse(qtdMlTexto.replaceAll(",", ".")) ?? 0;
    double? preco2 = double.tryParse(preco2Texto.replaceAll(",", ".")) ?? 0;
    double? qtdL = double.tryParse(qtdLTexto.replaceAll(",", ".")) ?? 0;

    qtdMl = qtdMl / 1000;
    double precoLitroMl = preco1 / qtdMl;
    double precoLitroL = preco2 / qtdL;

    if (precoLitroMl < precoLitroL) {
      setState(() {
        resultado = 'Opção A compensa mais';
      });
      diferenca = precoLitroL - precoLitroMl;
      setState(() {
        diferenca = (diferenca / precoLitroL) * 100;
      });
    } else if (precoLitroL < precoLitroMl) {
      setState(() {
        resultado = 'Opção B compensa mais';
      });
      diferenca = precoLitroMl - precoLitroL;
      setState(() {
        diferenca = (diferenca / precoLitroMl) * 100;
      });
    } else if (precoLitroL == precoLitroMl){
      setState(() {
        resultado = 'As opções tem o mesmo valor de Preço por Litro';
      });
    }
  }

  @override
  void dispose() {
    _preco1Controller.dispose();
    _quantidadeMlController.dispose();
    _preco2Controller.dispose();
    _quantidadeLController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Meu Primeiro App Flutter',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Calculadora Preço por Litro'),
          centerTitle: true,
          backgroundColor: const Color(0xCC5B3C84),
        ),
        body: Center(
          child: Container(
            width: 400,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.calculate, size: 80),
                const SizedBox(height: 40),

                Text(
                  'Opção A',
                  style: const TextStyle(fontSize: 20),
                ),
                TextField(
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  controller: _preco1Controller,
                  decoration: InputDecoration(
                    labelText: 'Preço',
                    hintText: 'Digite o Preço',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 10),

                TextField(
                  controller: _quantidadeMlController,
                  decoration: InputDecoration(
                    labelText: 'Digite a Quantidade',
                    hintText: 'Digite a quantidade em ml',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 30),

                Text(
                  'Opção B',
                  style: const TextStyle(fontSize: 20),
                ),
                TextField(
                  controller: _preco2Controller,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: InputDecoration(
                    labelText: 'Preço',
                    hintText: 'Digite o preço',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 10),

                TextField(
                  controller: _quantidadeLController,
                  decoration: InputDecoration(
                    labelText: 'Digite a Quantidade',
                    hintText: 'Digite a quantidade em Litros',
                    border: OutlineInputBorder(),
                  ),
                ),

                SizedBox(height: 20),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      calcularPrecoLitro();
                    },
                    child: const Text('Calcular'),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  resultado,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 18)
                ),
                if (diferenca > 0)
                Text(
                  'Diferença Percentual de ${diferenca.toStringAsFixed(2)}%'
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
