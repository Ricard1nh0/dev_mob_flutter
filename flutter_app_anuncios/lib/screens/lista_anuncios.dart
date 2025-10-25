// screens/lista_anuncios_screen.dart

import 'package:flutter/material.dart';
import '../models/anuncio.dart';
import 'formulario_anuncio.dart';

class ListaAnunciosScreen extends StatefulWidget {
  const ListaAnunciosScreen({Key? key}) : super(key: key);

  @override
  _ListaAnunciosScreenState createState() => _ListaAnunciosScreenState();
}

class _ListaAnunciosScreenState extends State<ListaAnunciosScreen> {
  final List<Anuncio> _anuncios = [];

  void _navegarParaFormulario({Anuncio? anuncio, int? index}) async {
    final resultado = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => FormularioAnuncioScreen(
          anuncioParaEditar: anuncio,
        ),
      ),
    );

    if (resultado != null && resultado is Anuncio) {
      setState(() {
        if (index != null) {
          _anuncios[index] = resultado;
        } else {
          _anuncios.add(resultado);
        }
      });
    }
  }

  void _removerAnuncio(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Confirmar Exclusão'),
        content: Text('Tem certeza que deseja remover este anúncio?'),
        actions: [
          TextButton(
            child: Text('Cancelar'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
          TextButton(
            child: Text('Remover'),
            onPressed: () {
              setState(() {
                _anuncios.removeAt(index);
              });
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Center(
          child: Text(
            'Meus Anúncios (OLX)',
            style: TextStyle(
              color: Colors.white,
               ),
              ),
        ),
      ),
      body: ListView.builder(
        itemCount: _anuncios.length,
        itemBuilder: (context, index) {
          final anuncio = _anuncios[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              title: Text(anuncio.titulo),
              subtitle: Text(
                'R\$ ${anuncio.preco.toStringAsFixed(2)}\n${anuncio.descricao}',
              ),
              isThreeLine: true,
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red[700]),
                onPressed: () => _removerAnuncio(index),
              ),
              onTap: () => _navegarParaFormulario(anuncio: anuncio, index: index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _navegarParaFormulario(),
      ),
    );
  }
}