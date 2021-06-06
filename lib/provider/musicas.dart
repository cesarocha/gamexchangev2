import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/musica.dart';
import 'package:flutter_app/data/musicas_exemplo.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Musicas with ChangeNotifier {
  static const _baseUrl =
      'https://code-gamexchange-default-rtdb.firebaseio.com/';
  final Map<String, Musica> _items = {...MUSICAS_EXEMPLO};

  List<Musica> get all {
    return [..._items.values];
  }

  int get count {
    return _items.length;
  }

  Musica byIndex(int index) {
    return _items.values.elementAt(index);
  }

  Future<void> put(Musica musica) async {
    if (musica == null) {
      return;
    }

    if (musica.id != null &&
        musica.id
            .trim()
            .isNotEmpty &&
        _items.containsKey(musica.id)) {
      await http.patch(
        Uri.parse("$_baseUrl/musicas/${musica.id}.json"),
        body: json.encode({
          'titulo': musica.titulo,
          'cantor': musica.cantor,
          'album': musica.album,
        }),
      );

      _items.update(
        musica.id,
            (_) =>
            Musica(
              id: musica.id,
              titulo: musica.titulo,
              cantor: musica.cantor,
              album: musica.album,
            ),
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

      final id = json.decode(response.body)['titulo'];
      print(json.decode(response.body));
      //adicionar
      _items.putIfAbsent(
          id,
              () =>
              Musica(
                id: musica.id,
                titulo: musica.titulo,
                cantor: musica.cantor,
                album: musica.album,
              ));
    }
    notifyListeners();
  }

  void remove(Musica musica) {
    if (musica != null && musica.id != null) {
      _items.remove(musica.id);
      notifyListeners();
    }
  }
}
