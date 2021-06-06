import 'package:flutter/material.dart';



class Musica {
  final String titulo;
  final String cantor;
  final String album;
  final int anolancamento;

  Musica(this.titulo,
      this.cantor,
      this.album,
      this.anolancamento,);

  @override
  String toString() {
    return 'Musica {titulo: $titulo, cantor: $cantor, album: $album, anolancamento: $anolancamento}';
  }
}


class MyApp extends StatelessWidget {

  final TextEditingController _controladorTitulo = TextEditingController();
  final TextEditingController _controladorCantor = TextEditingController();
  final TextEditingController _controladorAlbum = TextEditingController();
  final TextEditingController _controladorAnoLancamento = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'MusisT - Cadastro',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
        home: Scaffold(
            appBar: AppBar(
              title: Text('MusisT - Cadastro'),
              backgroundColor: Colors.black54,
              leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.white70),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  TextField( controller: _controladorTitulo,
                    decoration: InputDecoration(labelText: 'Título',
                      border: InputBorder.none,
                      icon: Icon(Icons.title_rounded),),),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextField( controller: _controladorCantor,
                      decoration: InputDecoration(labelText: 'Cantor',
                        border: InputBorder.none,
                        icon: Icon(Icons.mic_rounded),),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextField( controller: _controladorAlbum,
                      decoration: InputDecoration(labelText: 'Album',
                        border: InputBorder.none,
                        icon: Icon(Icons.album_rounded),),),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: TextField( controller: _controladorAnoLancamento,
                      decoration: InputDecoration(labelText: 'Ano',
                        border: InputBorder.none,
                        icon: Icon(Icons.calendar_today_rounded),),
                      keyboardType: TextInputType.number,),
                  ),  Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child:ElevatedButton(
                        child: Text('Cadastrar'),
                        onPressed: () {
                          final String titulo = _controladorTitulo.text;
                          final String cantor = _controladorCantor.text;
                          final String album = _controladorAlbum.text;
                          final int anolancamento = int.tryParse(_controladorAnoLancamento.text);
                          final Musica musicaNova = Musica(titulo, cantor, album, anolancamento);
                          print(musicaNova);
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.green, // background

                        ),
                      )
                  )
                ],
              ),
            )));
  }
}