import 'package:flutter/material.dart';
import 'package:sqlite_demo/person.dart';
import 'database.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late DatabaseHelper dbHelper;
  int _counter = 0;
  List<Person> persons = [];

  bool editMode = false;
  var editRecordId = 0;
  final idController = TextEditingController();
  final nameController = TextEditingController();
  final cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    try {
      dbHelper = DatabaseHelper();
      dbHelper.initDB().whenComplete(() async {
        print('==========> db init completed');
        List<Person> personsData = await dbHelper.retrieveUsers();
        setState(() {
          persons.addAll(personsData);
        });
        print('No of Persons ${persons.length}');
      });
    } catch (e) {
      print(e);
    }
  }

  void deleteDatabase() {
    dbHelper.deleteDb();
  }

  void saveData() async {
    try {
      print('No of Persons ${persons.length}');

      String name = nameController.text;
      String city = cityController.text;
      Person per = Person(name: name, city: city);
      if (editMode && editRecordId != 0) {
        int result = await dbHelper.updateUser(per, editRecordId);
        print(result);
        if (result > 0) {
          per.id = editRecordId;
          int personIndex =
              persons.indexWhere((personObj) => personObj.id == editRecordId);
          setState(() {
            if (persons.length - 1 >= personIndex) {
              persons[personIndex].name = name;
              persons[personIndex].city = city;
            }
          });
          // print('personIndex: $personIndex');
        }
      } else {
        int result = await dbHelper.insertUser(per);
        per.id = result;
        print('result: $result');
        setState(() {
          persons.add(per);
        });
      }
      nameController.clear();
      cityController.clear();
      editRecordId = 0;
      editMode = false;
    } catch (e) {
      print(e);
    }
  }

  void deleteUser(int id) async {
    try {
      int deleteId = await dbHelper.deleteUser(id);
      print('deleted user id: $deleteId');
      setState(() {
        persons.removeWhere((Person per) => per.id == id);
      });
    } catch (e) {
      print(e);
    }
  }

  void editUser(Person personData) {
    setState(() {
      editMode = true;
      editRecordId = personData.id;
    });
    nameController.text = personData.name;
    cityController.text = personData.city;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Card(
              child: Column(
            children: [
              // TextFormField(
              //   controller: idController,
              //   keyboardType: TextInputType.emailAddress,
              //   decoration: const InputDecoration(
              //     hintText: 'id',
              //     labelText: 'Id',
              //   ),
              // ),
              TextFormField(
                controller: nameController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter Name',
                  labelText: 'Name',
                ),
              ),
              TextFormField(
                controller: cityController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  hintText: 'Enter City',
                  labelText: 'City',
                ),
              ),
            ],
          )),
          Expanded(
              child: ListView.builder(
            itemCount: persons.length,
            itemBuilder: (context, index) {
              return Container(
                color: editRecordId == persons[index].id
                    ? Colors.amber
                    : Colors.white,
                child: Row(
                  children: [
                    Expanded(child: Text(persons[index].id.toString())),
                    Expanded(child: Text(persons[index].name)),
                    Expanded(child: Text(persons[index].city)),
                    IconButton(
                      onPressed: () {
                        deleteUser(persons[index].id);
                      },
                      icon: Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () {
                        editUser(persons[index]);
                      },
                      icon: Icon(Icons.edit),
                    ),
                  ],
                ),
              );
            },
          )),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: saveData,
        tooltip: 'Save Person Data',
        child: const Icon(Icons.save),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
