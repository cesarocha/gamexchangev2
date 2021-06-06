import 'package:flutter/material.dart';
import 'package:flutter_app/visao/musica_lista.dart';
import 'package:flutter_app/provider/musicas.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:flutter_app/visao/musica_form.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new Musicas(),
        )
      ],
      child: MaterialApp(
        title: 'MusisT',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
        routes: {
          AppRotas.HOME: (_) => MusicList(),
          AppRotas.MUSICA_FORM: (_) => MusicaForm()
        },
      ),
    );
  }
}
