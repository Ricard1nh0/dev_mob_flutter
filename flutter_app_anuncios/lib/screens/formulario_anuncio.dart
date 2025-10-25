// screens/formulario_anuncio_screen.dart

import 'package:flutter/material.dart';
import '../models/anuncio.dart';

class FormularioAnuncioScreen extends StatefulWidget {
  // Recebe um anúncio existente para edição. Se for nulo, é um novo cadastro.
  final Anuncio? anuncioParaEditar;

  const FormularioAnuncioScreen({Key? key, this.anuncioParaEditar})
      : super(key: key);

  @override
  _FormularioAnuncioScreenState createState() =>
      _FormularioAnuncioScreenState();
}

class _FormularioAnuncioScreenState extends State<FormularioAnuncioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descricaoController = TextEditingController();
  final _precoController = TextEditingController();

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    
    if (widget.anuncioParaEditar != null) {
      _isEditing = true;
      _tituloController.text = widget.anuncioParaEditar!.titulo;
      _descricaoController.text = widget.anuncioParaEditar!.descricao;
      _precoController.text = widget.anuncioParaEditar!.preco.toStringAsFixed(2);
    }
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descricaoController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  void _salvarAnuncio() {
    if (_formKey.currentState!.validate()) {
      final String titulo = _tituloController.text;
      final String descricao = _descricaoController.text;
      final double? preco = double.tryParse(_precoController.text);

      if (preco == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Por favor, insira um preço válido.')),
        );
        return;
      }

      final novoAnuncio = Anuncio(
        titulo: titulo,
        descricao: descricao,
        preco: preco,
      );

      Navigator.of(context).pop(novoAnuncio);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar Anúncio' : 'Novo Anúncio'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Icon(
                  Icons.assignment_add,
                  size: 80.0,
                ),
              ),
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                  ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _descricaoController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: OutlineInputBorder()
                ),
              ),
              SizedBox(height: 12),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(
                  labelText: 'Preço (Ex: 50.99)',
                  border: OutlineInputBorder(),
                  ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um preço';
                  }
                  if (double.tryParse(value) == null) {
                    return 'Por favor, insira um número válido';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarAnuncio,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}