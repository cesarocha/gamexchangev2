import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/game.dart';
import 'package:flutter_app/provider/games.dart';
import 'package:provider/provider.dart';

class GameForm extends StatefulWidget {
  @override
  _GameFormState createState() => _GameFormState();
}

class _GameFormState extends State<GameForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final _formData = Map<String, Object>();

  void initState(){
    super.initState();
    Provider.of<Games>(context, listen: false).carregarGame();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Game game = ModalRoute.of(context).settings.arguments;
    _loadFormData(game);
  }

  void _loadFormData(Game game) {
    if (game != null) {
      _formData['id'] = game.id;
      _formData['nome'] = game.nome;
      _formData['xchange'] = game.xchange;
      _formData['plataforma'] = game.plataforma;
      _formData['estado'] = game.estado;
      _formData['imageUrl'] = game.imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Game - Cadastro'),
          backgroundColor: Colors.black54,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final isValid = _form.currentState.validate();

                if (isValid) {
                  _form.currentState.save();

                  final game = Game(
                    id: _formData['id'],
                    nome: _formData['nome'],
                    xchange: _formData['xchange'],
                    plataforma: _formData['plataforma'],
                    estado: _formData['estado'],
                    imageUrl: _formData['imageUrl'],
                  );

                  setState(() {
                    _isLoading = true;
                  });

                  final games = Provider.of<Games>(context, listen: false);

                  try {
                    if (_formData['id'] == null) {
                      await games.adicionarGame(game);
                    } else {
                      await games.atualizarGame(game);
                    }
                    Navigator.of(context).pop();
                  } catch (error) {
                    await showDialog<Null>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Ocorreu um erro!'),
                        content: Text('Ocorreu um erro pra salvar o jogo!'),
                        actions: <Widget>[
                          FlatButton(
                            child: Text('Fechar'),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    );
                  } finally {
                    setState(() {
                      _isLoading = false;
                    });
                  }
                 // Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.all(15),
                child: Form(
                    key: _form,
                    child: Column(children: <Widget>[
                      TextFormField(
                        initialValue: _formData['nome'],
                        decoration: InputDecoration(
                          labelText: 'nome',
                          border: InputBorder.none,
                          icon: Icon(Icons.title_rounded),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo nome em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['game'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['xchange'],
                        decoration: InputDecoration(
                          labelText: 'xchange',
                          border: InputBorder.none,
                          icon: Icon(Icons.gamepad),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo xchange em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['xchange'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['plataforma'],
                        decoration: InputDecoration(
                          labelText: 'plataforma',
                          border: InputBorder.none,
                          icon: Icon(Icons.videogame_asset),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo plataforma em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['plataforma'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['estado'],
                        decoration: InputDecoration(
                          labelText: 'estado',
                          border: InputBorder.none,
                          icon: Icon(Icons.announcement_sharp),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo estado em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['estado'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['imageUrl'],
                        decoration: InputDecoration(
                          labelText: 'URL capa do jogo',
                          border: InputBorder.none,
                          icon: Icon(Icons.album_rounded),
                        ),
                        onSaved: (value) => _formData['imageUrl'] = value,
                      ),
                    ]))));
  }
}
