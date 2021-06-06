import 'package:flutter/material.dart';

class Musica{
  final String id;
  final String titulo;
  final String cantor;
  final String album;
//  final String anolancamento;

  const Musica({
    this.id,
    @required this.titulo,
    @required this.cantor,
    @required this.album,
   // @required this.anolancamento,
});
}