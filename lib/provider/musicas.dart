import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/musica.dart';
//import 'package:flutter_app/data/musicas_exemplo.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Musicas with ChangeNotifier {
  static const _baseUrl =
      'https://code-gamexchange-default-rtdb.firebaseio.com/musicas';
  List<Musica> _items = []; /*{...MUSICAS_EXEMPLO}*/

  List<Musica> get items => [..._items];

  int get count {
    return _items.length;
  }

  /*Musica byIndex(int index){
    return _items.elementAt(index);
  }*/

  Future<void> carregarMusica() async {
    final response = await http.get(Uri.parse("$_baseUrl.json"));
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    if (data != null) {
      data.forEach((musicaId, musicaData) {
        _items.add(Musica(
          id: musicaId,
          titulo: musicaData['titulo'],
          cantor: musicaData['cantor'],
          album: musicaData['album'],
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> adicionarMusica(Musica novaMusica) async {
    final response = await http.post(
      Uri.parse("$_baseUrl.json"),
      body: json.encode({
        'titulo': novaMusica.titulo,
        'cantor': novaMusica.cantor,
        'album': novaMusica.album,
      }),
    );

    _items.add(Musica(
      id: json.decode(response.body)['name'],
      titulo: novaMusica.titulo,
      cantor: novaMusica.cantor,
      album: novaMusica.album,
    ));
    notifyListeners();
  }

  Future<void> atualizarMusica(Musica musica) async {
    if (musica == null || musica.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == musica.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse("$_baseUrl/${musica.id}.json"),
        body: json.encode({
          'titulo': musica.titulo,
          'cantor': musica.cantor,
          'album': musica.album,
        }),
      );
      _items[index] = musica;
      notifyListeners();
    }
  }

  Future<void> removerMusica(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final musica = _items[index];
      _items.remove(musica);
      notifyListeners();

      final response = await http.delete(Uri.parse("$_baseUrl/${musica.id}.json"));

      if (response.statusCode >= 400) {
        _items.insert(index, musica);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do produto.');
      }
    }
  }
  /*Future<void> loadMusica() async{

  }*/
  /*Future<void> put(Musica musica) async {
    if (musica == null) {
      return;
    }

    if (musica.id != null &&
        musica.id
            .trim()
            .isNotEmpty &&
        _items.contains(musica.id)) {
      final response = await http.patch(
        Uri.parse("$_baseUrl/musicas/${musica.id}.json"),
        body: json.encode({
          'titulo': musica.titulo,
          'cantor': musica.cantor,
          'album': musica.album,
        }),
      );
    } else {
      final response = await http.post(
        Uri.parse("$_baseUrl/musicas.json"),
        body: json.encode({
          'titulo': musica.titulo,
          'cantor': musica.cantor,
          'album': musica.album,
        }),
      );

      //adicionar
      _items.add( Musicas(
                id: json.decode(response.body)['titulo'],
                titulo: musica.titulo,
                cantor: musica.cantor,
                album: musica.album,
              ));
      )

    }
    notifyListeners();
  }

  void remove(Musica musica) {
    if (musica != null && musica.id != null) {
      _items.remove(musica.id);
      notifyListeners();
    }
  }*/
}

