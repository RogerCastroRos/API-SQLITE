import 'package:api_to_sqlite/src/models/employee_model.dart';
import 'package:api_to_sqlite/src/providers/db_provider.dart';
import 'package:api_to_sqlite/src/providers/employee_api_provider.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Api to sqlite'),
          centerTitle: true,
          actions: <Widget>[
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.settings_input_antenna),
                onPressed: () async {
                  await _loadFromApi();
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              child: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () async {
                  await _deleteData();
                },
              ),
            ),
          ],
        ),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : _buildEmployeeListView(),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const SecondRoute()),
              );
            }));
  }

  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });

    var apiProvider = EmployeeApiProvider();
    await apiProvider.getAllEmployees();

    // wait for 2 seconds to simulate loading of data
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      isLoading = false;
    });
  }

  _deleteData() async {
    setState(() {
      isLoading = true;
    });

    await DBProvider.db.deleteAllEmployees();

    // wait for 1 second to simulate loading of data
    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });

    // ignore: avoid_print
    print('All employees deleted');
  }

  _buildEmployeeListView() {
    return FutureBuilder(
      future: DBProvider.db.getAllEmployees(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return ListView.separated(
            separatorBuilder: (context, index) => const Divider(
              color: Colors.black12,
            ),
            itemCount: snapshot.data.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: Container(
                  child: CircleAvatar(
                      radius: 35.0,
                      backgroundImage:
                          NetworkImage(snapshot.data[index].imatge)),
                ),
                title: Text(
                    "Nom: ${snapshot.data[index].nom} ${snapshot.data[index].equip} "),
                subtitle: Text('Punts: ${snapshot.data[index].punts}'),
                trailing: new Column(
                  children: <Widget>[
                    new Container(
                      child: new IconButton(
                        icon: new Icon(Icons.delete),
                        onPressed: () {
                          DBProvider.db
                              .newDeleteEmployee(snapshot.data[index].id);
                          Navigator.pushNamed(context, "home");
                        },
                      ),
                      margin: EdgeInsets.only(top: 8.0),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
  }
}

class SecondRoute extends StatelessWidget {
  const SecondRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final idController = TextEditingController();
    final nomController = TextEditingController();
    final equipController = TextEditingController();
    final puntsController = TextEditingController();
    final imatgeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: Text('afegir ciclistes')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: "id"),
              // controller: _controller, // afegim un controlador
              onSubmitted: (what) {
                Navigator.of(context).pop(what);
              },
            ),
            TextField(
              controller: nomController,
              decoration: InputDecoration(labelText: "Nom"),
              // controller: _controller, // afegim un controlador
              onSubmitted: (what) {
                Navigator.of(context).pop(what);
              },
            ),
            TextField(
              controller: equipController,
              decoration: InputDecoration(labelText: "Equip"),
              // controller: _controller, // afegim un controlador
              onSubmitted: (what) {
                Navigator.of(context).pop(what);
              },
            ),
            TextField(
              controller: puntsController,
              decoration: InputDecoration(labelText: "Punts"),
              // controller: _controller, // afegim un controlador
              onSubmitted: (what) {
                Navigator.of(context).pop(what);
              },
            ),
            TextField(
              controller: imatgeController,
              decoration: InputDecoration(labelText: "Imatge"),
              // controller: _controller, // afegim un controlador
              onSubmitted: (what) {
                Navigator.of(context).pop(what);
              },
            ),
            ElevatedButton(
                // afegim un boto per crear noves tasques
                onPressed: () {
                  DBProvider.db.newInsertEmployee(TopUci(
                      id: int.parse(idController.text),
                      nom: nomController.text,
                      equip: equipController.text,
                      punts: puntsController.text,
                      imatge: imatgeController.text));
                  Navigator.pushNamed(context, "home");
                },
                child: Text("Afegir ")) //
          ],
        ),
      ),
    );
  }
}
