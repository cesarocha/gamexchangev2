import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/user.dart';
import 'package:http/http.dart' as http;
import 'dart:core';

class Users with ChangeNotifier {
  static const _baseUrl =
      'https://code-gamexchange-default-rtdb.firebaseio.com/users';
  List<User> _items = []; /*{...GAMES_EXEMPLO}*/

  List<User> get items => [..._items];

  int get Usercount {
    return _items.length;
  }

  Future<void> carregarUser() async {
    final response = await http.get(Uri.parse("$_baseUrl.json"));
    Map<String, dynamic> data = json.decode(response.body);

    _items.clear();
    if (data != null) {
      data.forEach((userId, userData) {
        _items.add(User(
          id: userId,
          nome: userData['nome'],
          nickname: userData['nickname'],
          email: userData['email'],
          telefone: userData['telefone'],
          senha: userData['senha'],
          termo: userData['termo'],
        ));
      });
      notifyListeners();
    }
    return Future.value();
  }

  Future<void> adicionarUser(User novoUser) async {
    final response = await http.post(
      Uri.parse("$_baseUrl.json"),
      body: json.encode({
        'nome': novoUser.nome,
        'nickname': novoUser.nickname,
        'email': novoUser.email,
        'telefone': novoUser.telefone,
        'senha': novoUser.senha,
        'termo': novoUser.termo,
      }),
    );

    _items.add(User(
      id: json.decode(response.body)['name'],
      nome: novoUser.nome,
      nickname: novoUser.nickname,
      email: novoUser.email,
      telefone: novoUser.telefone,
      senha: novoUser.senha,
      termo: novoUser.termo,
    ));
    notifyListeners();
  }

  Future<void> atualizarUser(User user) async {
    if (user == null || user.id == null) {
      return;
    }

    final index = _items.indexWhere((prod) => prod.id == user.id);
    if (index >= 0) {
      await http.patch(
        Uri.parse("$_baseUrl/${user.id}.json"),
        body: json.encode({
          'nome': user.nome,
          'nickname': user.nickname,
          'email': user.email,
          'telefone': user.telefone,
          'senha': user.senha,
          'termo': user.termo,
        }),
      );
      _items[index] = user;
      notifyListeners();
    }
  }

  Future<void> removerUser(String id) async {
    final index = _items.indexWhere((prod) => prod.id == id);
    if (index >= 0) {
      final user = _items[index];
      _items.remove(user);
      notifyListeners();

      final response = await http.delete(Uri.parse("$_baseUrl/${user.id}.json"));

      if (response.statusCode >= 400) {
        _items.insert(index, user);
        notifyListeners();
        throw HttpException('Ocorreu um erro na exclusão do jogo.');
      }
    }
  }
}

