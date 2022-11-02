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
  final _controller = ScrollController();
  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      if (_controller.position.maxScrollExtent == _controller.offset) {
        listUser.page++;
        listUser.getUsers();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Lista de usuários"),
          actions: const [Icon(Icons.search)],
        ),
        body: Observer(
          builder: (context) => FutureBuilder(
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
                          controller: _controller,
                          itemCount: users.length +1,
                          itemBuilder: ((context, index) {
                            Map<String, dynamic> user = users[index];
                            if (index < user.length) {
                              return Card(
                                child: ListTile(
                                  leading: SizedBox(
                                    width: 30,
                                    height: 30,
                                    child: Image.network(
                                        user['picture']['medium'].toString()),
                                  ),
                                  title:
                                      Text('Nome:. ${user['name']['first']}'),
                                  subtitle: Text('E-mail:. ${user['email']}'),
                                ),
                              );
                            } else {
                              return const Padding(
                                padding: EdgeInsets.symmetric(vertical: 15),
                                child:
                                    Center(child: CircularProgressIndicator()),
                              );
                            }
                          }));
                    }
                    break;
                }
              })),
        ));
  }
}
