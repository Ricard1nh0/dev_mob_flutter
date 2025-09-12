import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de IMC',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          filled: true,
          fillColor: Colors.indigo.shade50,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const IMCCalculatorScreen(),
    );
  }
}

class IMCCalculatorScreen extends StatefulWidget {
  const IMCCalculatorScreen({super.key});

  @override
  State<IMCCalculatorScreen> createState() => _IMCCalculatorScreenState();
}

class _IMCCalculatorScreenState extends State<IMCCalculatorScreen> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();

  double? _imcResult;
  String _classification = '';
  Color _resultColor = Colors.black;

  void _calculateIMC() {
    final double? height = double.tryParse(_heightController.text.replaceAll(',', '.'));
    final double? weight = double.tryParse(_weightController.text.replaceAll(',', '.'));

    if (height == null || height <= 0 || weight == null || weight <= 0) {
      setState(() {
        _classification = 'Por favor, insira valores válidos.';
        _imcResult = null;
        _resultColor = Colors.red;
      });
      return;
    }

    final double imc = weight / (height * height);

    setState(() {
      _imcResult = imc;
      if (imc < 18.5) {
        _classification = 'Abaixo do peso';
        _resultColor = Colors.orangeAccent;
      } else if (imc >= 18.5 && imc <= 24.9) {
        _classification = 'Peso ideal (parabéns)';
        _resultColor = Colors.green;
      } else if (imc >= 25.0 && imc <= 29.9) {
        _classification = 'Levemente acima do peso';
        _resultColor = Colors.yellow.shade800;
      } else if (imc >= 30.0 && imc <= 34.9) {
        _classification = 'Obesidade grau I';
        _resultColor = Colors.orange;
      } else if (imc >= 35.0 && imc <= 39.9) {
        _classification = 'Obesidade grau II (severa)';
        _resultColor = Colors.deepOrange;
      } else {
        _classification = 'Obesidade III (mórbida)';
        _resultColor = Colors.red;
      }
    });
  }

  void _resetFields() {
    _heightController.clear();
    _weightController.clear();
    setState(() {
      _imcResult = null;
      _classification = '';
    });
  }
  
  @override
  void dispose() {
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetFields,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Icon(Icons.monitor_weight_outlined, size: 80, color: Colors.indigo.shade200),
            const SizedBox(height: 20),

            TextField(
              controller: _heightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Altura (m)',
                hintText: 'Ex: 1,75',
                prefixIcon: Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 20),

            TextField(
              controller: _weightController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: const InputDecoration(
                labelText: 'Peso (Kg)',
                hintText: 'Ex: 70,5',
                prefixIcon: Icon(Icons.scale_outlined),
              ),
            ),
            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: _calculateIMC,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueGrey,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold,),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: const Text('CALCULAR'),
            ),
            const SizedBox(height: 30),

            if (_classification.isNotEmpty)
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      if (_imcResult != null)
                        Text(
                          'Seu IMC é: ${_imcResult!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      const SizedBox(height: 10),
                      Text(
                        _classification,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          color: _resultColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}