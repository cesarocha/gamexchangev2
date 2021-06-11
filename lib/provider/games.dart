import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/game.dart';
//import 'package:flutter_app/data/musicas_exemplo.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Games with ChangeNotifier {
  static const _baseUrl =
      'https://code-gamexchange-default-rtdb.firebaseio.com/games';
  List<Game> _items = []; /*{...GAMES_EXEMPLO}*/

  List<Game> get items => [..._items];

  int get count {
    return _items.length;
  }

  Future<void> carregarGame() async {
    final response = await http.get(Uri.parse("$_baseUrl.json"));
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    if (data != null) {
      data.forEach((gameId, gameData) {
        _items.add(Game(
          id: gameId,
          nome: gameData['nome'],
          xchange: gameData['xchange'],
          plataforma: gameData['plataforma'],
          estado: gameData['estado'],
          imageUrl: gameData['imageUrl'],
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> adicionarGame(Game novoGame) async {
    final response = await http.post(
      Uri.parse("$_baseUrl.json"),
      body: json.encode({
        'nome': novoGame.nome,
        'xchange': novoGame.xchange,
        'plataforma': novoGame.plataforma,
        'estado': novoGame.estado,
        'imageUrl': novoGame.imageUrl,
      }),
    );

    _items.add(Game(
      id: json.decode(response.body)['name'],
      nome: novoGame.nome,
      xchange: novoGame.xchange,
      plataforma: novoGame.plataforma,
      estado: novoGame.estado,
      imageUrl: novoGame.imageUrl,
    ));
    notifyListeners();
  }

  Future<void> atualizarGame(Game game) async {
    if (game == null || game.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == game.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse("$_baseUrl/${game.id}.json"),
        body: json.encode({
          'nome': game.nome,
          'xchange': game.xchange,
          'plataforma': game.plataforma,
          'estado': game.estado,
          'imageUrl': game.imageUrl,
        }),
      );
      _items[index] = game;
      notifyListeners();
    }
  }

  Future<void> removerGame(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final game = _items[index];
      _items.remove(game);
      notifyListeners();

      final response = await http.delete(Uri.parse("$_baseUrl/${game.id}.json"));

      if (response.statusCode >= 400) {
        _items.insert(index, game);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do jogo.');
      }
    }
  }
}

