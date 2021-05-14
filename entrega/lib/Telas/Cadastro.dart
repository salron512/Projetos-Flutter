import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Cadastro extends StatefulWidget {
  @override
  _CadastroState createState() => _CadastroState();
}

class _CadastroState extends State<Cadastro> {
  var _mascaraTelefone = new MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  bool _mostrarSenha = false;
  bool _motrarSenhaConfirma = false;
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerTelefone = TextEditingController();
  TextEditingController _controllerWhatsapp = TextEditingController();
  TextEditingController _controllerEndereco = TextEditingController();
  TextEditingController _controllerBairro = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  TextEditingController _controllerConfirmaSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastro"),
      ),
      body: Container(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Padding(
                  padding: EdgeInsets.only(top: 32, bottom: 15),
                  child: Container(
                    width: 150,
                    height: 150,
                    child: Image.asset("images/man.png"),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    keyboardType: TextInputType.name,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        labelText: "Nome completo",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerNome,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    inputFormatters: [_mascaraTelefone],
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            setState(() {
                              _controllerTelefone.clear();
                            });
                          },
                        ),
                        labelText: "Telefone",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerTelefone,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                    autofocus: true,
                    inputFormatters: [_mascaraTelefone],
                    keyboardType: TextInputType.phone,
                    textCapitalization: TextCapitalization.sentences,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.clear,
                          ),
                          onPressed: () {
                            setState(() {
                              _controllerWhatsapp.clear();
                            });
                          },
                        ),
                        labelText: "Whatsapp",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerWhatsapp,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Endereço",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerEndereco),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 8),
                  child: TextField(
                      autofocus: true,
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                          labelText: "Bairro",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15))),
                      controller: _controllerBairro),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    obscureText: !_mostrarSenha,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _mostrarSenha
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _mostrarSenha = !_mostrarSenha;
                            });
                          },
                        ),
                        hintText: "Digite a senha",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerSenha,
                  ),
                ),
                  Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: TextField(
                    obscureText: !_motrarSenhaConfirma,
                    keyboardType: TextInputType.text,
                    style: TextStyle(
                      fontSize: 20,
                    ),
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: _motrarSenhaConfirma
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _motrarSenhaConfirma = !_motrarSenhaConfirma;
                            });
                          },
                        ),
                        hintText: "Digite a senha novamente",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15))),
                    controller: _controllerConfirmaSenha,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 10),
                  child: ElevatedButton(
                    child: Text(
                      "Cadastrar",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                    ),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
