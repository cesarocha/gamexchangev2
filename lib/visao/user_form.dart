import 'package:flutter/material.dart';
import 'package:flutter_app/modelo/user.dart';
import 'package:flutter_app/provider/users.dart';
import 'package:provider/provider.dart';

class UserForm extends StatefulWidget {
  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  final _form = GlobalKey<FormState>();
  bool _isLoading = false;
  final _formData = Map<String, Object>();

  void initState(){
    super.initState();
    Provider.of<Users>(context, listen: false).carregarUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final User user = ModalRoute.of(context).settings.arguments;
    _loadFormData(user);
  }

  void _loadFormData(User user) {
    if (user != null) {
      _formData['id'] = user.id;
      _formData['nome'] = user.nome;
      _formData['nickname'] = user.nickname;
      _formData['email'] = user.email;
      _formData['telefone'] = user.telefone;
      _formData['senha'] = user.senha;
      _formData['termo'] = user.termo;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User - Cadastro'),
          backgroundColor: Colors.black54,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.save),
              onPressed: () async {
                final isValid = _form.currentState.validate();

                if (isValid) {
                  _form.currentState.save();

                  final user = User(
                    id: _formData['id'],
                    nome: _formData['nome'],
                    nickname: _formData['nickname'],
                    email: _formData['email'],
                    telefone: _formData['telefone'],
                    senha: _formData['senha'],
                    termo: _formData['termo'],
                  );

                  setState(() {
                    _isLoading = true;
                  });

                  final users = Provider.of<Users>(context, listen: false);

                  try {
                    if (_formData['id'] == null) {
                      await users.adicionarUser(user);
                    } else {
                      await users.atualizarUser(user);
                    }
                    Navigator.of(context).pop();
                  } catch (error) {
                    await showDialog<Null>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text('Ocorreu um erro!'),
                        content: Text('Ocorreu um erro pra salvar o usuário!'),
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
                          labelText: 'Nome',
                          border: InputBorder.none,
                          icon: Icon(Icons.account_box),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo nome em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['nome'] = value,
                      ),
                      //NICKNAME
                      TextFormField(
                        initialValue: _formData['nickname'],
                        decoration: InputDecoration(
                          labelText: 'Nickname',
                          border: InputBorder.none,
                          icon: Icon(Icons.gamepad),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo nickname em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['nickname'] = value,
                      ),
                      //E-MAIL
                      TextFormField(
                        initialValue: _formData['email'],
                        decoration: InputDecoration(
                          labelText: 'E-mail',
                          border: InputBorder.none,
                          icon: Icon(Icons.email),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo e-mail em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['email'] = value,
                      ),
                      //TELEFONE
                      TextFormField(
                        initialValue: _formData['telefone'],
                        decoration: InputDecoration(
                          labelText: '(xx) xxxx-xxxxx',
                          border: InputBorder.none,
                          icon: Icon(Icons.phone),
                        ),
                        validator: (value) {
                          // ignore: missing_return
                          if (value == null || value.trim().isEmpty) {
                            return 'Campo telefone em branco';
                          }
                          return null;
                        },
                        onSaved: (value) => _formData['telefone'] = value,
                      ),
                      //SENHA
                      TextFormField(
                        initialValue: _formData['senha'],
                        decoration: InputDecoration(
                          labelText: 'Password',
                          border: InputBorder.none,
                          icon: Icon(Icons.lock),
                        ),
                        onSaved: (value) => _formData['senha'] = value,
                      ),
                      CheckboxListTile(
                        title: Text("Concordo com os termos e condições de uso"),
                        value: _formData['termo'],
                        onChanged: (newValue) {
                          setState(() {
                            _formData['termo'] = newValue;
                          });
                        },
                        controlAffinity: ListTileControlAffinity.leading,  //  <-- leading Checkbox
                      ),
                    ]))));
  }
}
