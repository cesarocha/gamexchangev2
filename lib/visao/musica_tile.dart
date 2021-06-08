import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/musica.dart';
import 'package:flutter_app/provider/musicas.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:provider/provider.dart';

class MusicTile extends StatefulWidget {
  final Musica musica;

  const MusicTile(this.musica);

  @override
  _MusicTileState createState() => _MusicTileState();
}

class _MusicTileState extends State<MusicTile> {
  bool _isLoading = true;

  void initState() {
    super.initState();
    Provider.of<Musicas>(context, listen: false).carregarMusica().then((_) {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final albumURL = widget.musica.album == null || widget.musica.album.isEmpty
        ? CircleAvatar(child: Icon(Icons.album))
        : CircleAvatar(backgroundImage: NetworkImage(widget.musica.album));
    return ListTile(
      leading: albumURL,
      title: Text(widget.musica.titulo),
      subtitle: Text(widget.musica.cantor),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              color: Colors.indigoAccent,
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRotas.MUSICA_FORM,
                  arguments: widget.musica,
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
                        title: Text('Excluir Música'),
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
                    Provider.of<Musicas>(context, listen: false)
                        .removerMusica(widget.musica.id);
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
