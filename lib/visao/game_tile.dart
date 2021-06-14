import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/game.dart';
import 'package:flutter_app/provider/games.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:provider/provider.dart';

class GameTile extends StatefulWidget {
  final Game game;

  const GameTile(this.game);

  @override
  _GameTileState createState() => _GameTileState();
}

class _GameTileState extends State<GameTile> {
  bool _isLoading = true;

  void initState() {
    super.initState();
    Provider.of<Games>(context, listen: false).carregarGames().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final imageUrl = widget.game.imageUrl == null || widget.game.imageUrl.isEmpty
        ? CircleAvatar(child: Icon(Icons.album))
        : CircleAvatar(backgroundImage: NetworkImage(widget.game.imageUrl));
    return ListTile(
      leading: imageUrl,
      title: Text(widget.game.nome),
      subtitle: Text(widget.game.xchange),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.indigoAccent,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRotas.GAME_FORM,
                  arguments: widget.game,
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              color: Colors.redAccent,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) =>
                      AlertDialog(
                        title: Text('Excluir Jogo'),
                        content: Text('Tem certeza?'),
                        actions: <Widget>[
                          FlatButton(
                              child: Text('Não'),
                              onPressed: () => Navigator.of(context).pop(false),
                          ),
                          FlatButton(
                              child: Text('Sim'),
                              onPressed: () => Navigator.of(context).pop(true),
                          ),
                        ],
                      ),
                ).then((confimed) {
                  if (confimed) {
                    Provider.of<Games>(context, listen: false)
                        .removerGame(widget.game.id);
                  }
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
