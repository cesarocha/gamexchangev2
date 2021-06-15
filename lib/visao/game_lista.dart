import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/visao/game_tile.dart';
import 'package:flutter_app/provider/games.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:provider/provider.dart';

class GameList extends StatelessWidget {
  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Games>(context, listen: false).carregarGames();
  }

  @override
  Widget build(BuildContext context) {
    final Games games = Provider.of(context);
    final game = games.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('gameXchange'),
        backgroundColor: Colors.black54,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(
                AppRotas.USER_FORM,
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => _refreshProducts(context),
        child: Padding(
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: games.count,
            itemBuilder: (ctx, i) => Column(children: <Widget>[
              GameTile(game[i]),
              Divider(),
            ]),
          ),
        ),
      ),
    );
  }
}
