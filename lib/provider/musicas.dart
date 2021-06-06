import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/musica.dart';
import 'package:flutter_app/data/musicas_exemplo.dart';

class Musicas with ChangeNotifier{
  final Map<String, Musica> _items = {...MUSICAS_EXEMPLO};

  List<Musica> get all {
    return [..._items.values];
  }

  int get count{
    return _items.length;
  }
  Musica byIndex (int index){
    return _items.values.elementAt(index);
  }

  void put(Musica musica){
    if(musica == null){
      return;
    }

    if(musica.id != null &&
        musica.id.trim().isNotEmpty &&
        _items.containsKey(musica.id)){
      _items.update(musica.id, (_) => Musica(
        id: musica.id,
        titulo: musica.titulo,
        cantor:musica.cantor,
        album: musica.album,
      ));
    } else {
      //adicionar
      final id = Random().nextDouble().toString();
      _items.putIfAbsent(
          id,()=> Musica(
        id: musica.id,
        titulo: musica.titulo,
        cantor: musica.cantor,
        album: musica.album,
      ));
    }
    notifyListeners();
  }
  void remove(Musica musica) {
    if(musica != null && musica.id != null){
      _items.remove(musica.id);
      notifyListeners();
    }
  }
}