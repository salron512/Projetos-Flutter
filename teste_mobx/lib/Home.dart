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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de usuários"),
          actions: const [Icon(Icons.search)],
        ),
        body: Observer(
          builder: (_) => FutureBuilder(
              future: listUser.getUsers(),
              builder: ((context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                    return const Center();

                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );

                  case ConnectionState.active:
                    return const Center();

                  case ConnectionState.done:
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text("Sem resultados "),
                      );
                    } else {
                      List users = snapshot.data;
                      return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: ((context, index) {
                            Map<String, dynamic> user = users[index];
                            return Card(
                              child: ListTile(
                                leading: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Image.network(
                                      user['picture']['medium'].toString()),
                                ),
                                title: Text('Nome:. ${user['name']['first']}'),
                                subtitle: Text('E-mail:. ${user['email']}'),
                              ),
                            );
                          }));
                    }
                    break;
                }
              })),
        ));
  }
}
