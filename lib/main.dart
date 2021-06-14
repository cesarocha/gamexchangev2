import 'package:flutter/material.dart';
import 'package:flutter_app/visao/game_lista.dart';
import 'package:flutter_app/provider/games.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:flutter_app/visao/game_form.dart';
import 'package:flutter_app/visao/user_form.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => new Games(),
        )
      ],
      child: MaterialApp(
        title: 'gameXchange',
        theme: new ThemeData(scaffoldBackgroundColor: Colors.white),
        routes: {
          AppRotas.HOME: (_) => GameList(),
          AppRotas.GAME_FORM: (_) => GameForm(),
          AppRotas.USER_FORM: (_) => UserForm()
        },
      ),
    );
  }
}
