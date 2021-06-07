import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/musica.dart';
import 'package:flutter_app/provider/musicas.dart';
import 'package:provider/provider.dart';

class MusicaForm extends StatefulWidget {
  @override
  _MusicaFormState createState() => _MusicaFormState();
}

class _MusicaFormState extends State<MusicaForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final Map<String, String> _formData = {};

  void _loadFormData(Musica musica) {
    if (musica != null) {
      _formData['id'] = musica.id;
      _formData['titulo'] = musica.titulo;
      _formData['cantor'] = musica.cantor;
      _formData['album'] = musica.album;
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    final Musica musica = ModalRoute.of(context).settings.arguments;
    _loadFormData(musica);
  }

  void initState(){
    super.initState();
    Provider.of<Musicas>(context, listen: false).carregarMusica();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MusisT - Cadastro'),
          backgroundColor: Colors.black54,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final isValid = _form.currentState.validate();

                if (isValid) {
                  _form.currentState.save();

                  setState(() {
                    _isLoading = true;
                  });

                  await Provider.of<Musicas>(context, listen: false).adicionarMusica(
                    Musica(
                      id: _formData['id'],
                      titulo: _formData['titulo'],
                      cantor: _formData['cantor'],
                      album: _formData['album'],
                    ),
                  );

                  setState(() {
                    _isLoading = false;
                  });

                  Navigator.of(context).pop();
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
                        initialValue: _formData['titulo'],
                        decoration: InputDecoration(
                          labelText: 'Título',
                          border: InputBorder.none,
                          icon: Icon(Icons.title_rounded),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo título em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['titulo'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['cantor'],
                        decoration: InputDecoration(
                          labelText: 'Cantor',
                          border: InputBorder.none,
                          icon: Icon(Icons.mic_rounded),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo cantor em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['cantor'] = value,
                      ),
                      TextFormField(
                        initialValue: _formData['album'],
                        decoration: InputDecoration(
                          labelText: 'URL capa do álbum',
                          border: InputBorder.none,
                          icon: Icon(Icons.album_rounded),
                        ),
                        onSaved: (value) => _formData['album'] = value,
                      ),
                    ]))));
  }
}
