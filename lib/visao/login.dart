import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/user.dart';
import 'package:flutter_app/provider/users.dart';
import 'package:flutter_app/rotas/AppRotas.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  Future<void> _refreshProducts(BuildContext context) {
    return Provider.of<Users>(context, listen: false).carregarUser();
  }

  @override
  Widget build(BuildContext context) {
    final Users users = Provider.of(context);
    final user = users.items;

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
            itemCount: users.Usercount,
            itemBuilder: (ctx, i) => Column(children: <Widget>[
              //Login(user[i]),
              Divider(),
            ]),
          ),
        ),
      ),
    );
  }
}
