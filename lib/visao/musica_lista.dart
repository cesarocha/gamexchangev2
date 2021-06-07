import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/visao/musica_tile.dart';
import 'package:flutter_app/provider/musicas.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:provider/provider.dart';

class MusicList extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final Musicas musicas = Provider.of(context);
    final musica = musicas.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('MusisT'),
        backgroundColor: Colors.black54,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRotas.MUSICA_FORM,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: musicas.count,
        itemBuilder: (ctx, i) => Column(
          children: <Widget>[
            Divider(),
            MusicTile(musica[i]),
          ]
        ),
      ),
    );
  }
}
