// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:teste_mobx/listUsers.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final listUser = ListUser();

class _HomeState extends State<Home> {
  _alertUser(Map<String, dynamic> userInfo) {
    showDialog(
        context: context,
        builder: ((context) {
          return AlertDialog(
            title: const Text("Informações do usuário"),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Container(
                        alignment: Alignment.topCenter,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: userInfo != null
                              ? NetworkImage(userInfo['picture']['large'])
                              : null,
                          backgroundColor: Colors.grey,
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('Nome: ${userInfo['name']['first']} '
                        '${userInfo['name']['last']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('Sexo: ${userInfo['gender']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('Idade: ${userInfo['dob']['age']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('E-mail: ${userInfo['email']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                        'Endereço: ${userInfo['location']['street']['name']} '
                        '${userInfo['location']['street']['number']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('Cidade: ${userInfo['location']['city']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('Estado: ${userInfo['location']['state']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text('País: ${userInfo['location']['country']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                        'Código postal: ${userInfo['location']['postcode']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                        'Latitude: ${userInfo['location']['coordinates']['latitude']}'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                        'Longitude: ${userInfo['location']['coordinates']['longitude']}'),
                  ),
                    Padding(
                    padding: const EdgeInsets.only(bottom: 3),
                    child: Text(
                        'Longitude: ${userInfo['location']
                        ['coordinates']['longitude']}'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: (() => Navigator.pop(context)),
                  child: const Text("OK"))
            ],
          );
        }));
  }

  @override
  void initState() {
    listUser.getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de usuários"),
          actions: const [Icon(Icons.search)],
        ),
        body: listUser.listUser == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Observer(
                builder: (context) => Column(
                      children: [
                        Expanded(
                            child: ListView.builder(
                                //controller: _controller,
                                itemCount: listUser.listUser.length,
                                itemBuilder: ((context, index) {
                                  Map<String, dynamic> user =
                                      listUser.listUser[index];

                                  return Card(
                                    color: const Color(0xff202125),
                                    //elevation: 8,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(3),
                                      child: ListTile(
                                        leading: CircleAvatar(
                                          radius: 30,
                                          backgroundImage: user != null
                                              ? NetworkImage(
                                                  user['picture']['large'])
                                              : null,
                                          backgroundColor: Colors.grey,
                                        ),
                                        title: Text(
                                          'Nome: ${user['name']['first']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        subtitle: Text(
                                          'E-mail: ${user['email']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        onTap: (() {
                                          _alertUser(user);
                                        }),
                                      ),
                                    ),
                                  );
                                }))),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              child: const Text("Carregar mais usuários"),
                              onPressed: (() {
                                listUser.getUsers();
                              }),
                            ),
                          ),
                        )
                      ],
                    )));
  }
}
