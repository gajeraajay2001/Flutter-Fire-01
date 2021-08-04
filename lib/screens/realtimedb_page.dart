import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire01/models/data_Model.dart';
import 'package:flutterfire01/services/service.dart';

class RealTimeDBPage extends StatefulWidget {
  static const routes = "realtime_db_page";

  @override
  _RealTimeDBPageState createState() => _RealTimeDBPageState();
}

class _RealTimeDBPageState extends State<RealTimeDBPage> {
  final fb = FirebaseDatabase.instance;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();
  late DatabaseReference databaseReference;
  int id = 1;
  String name = "";
  int age = 0, rollNumber = 0;
  @override
  void initState() {
    databaseReference = fb.reference();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "RealTime Database",
          style: TextStyle(fontSize: 23),
        ),
        centerTitle: true,
      ),
      body: FirebaseAnimatedList(
        shrinkWrap: true,
        query: databaseReference,
        itemBuilder: (context, DataSnapshot snapshot, animation, index) {
          List<DataModel> data = [];
          Map<String, dynamic> temp = snapshot.value.cast<String, dynamic>();
          temp.forEach((key, value) {
            data.add(DataModel(
                name: value["name"],
                age: value["age"],
                rollNumber: value["rollNumber"]));
          });
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.9,
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Text(data[index].rollNumber.toString()),
                    title: Text(data[index].name.toString()),
                    subtitle: Text("Age := ${data[index].age.toString()}"),
                    trailing: Wrap(
                      children: [
                        IconButton(
                          onPressed: () {},
                          icon: Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          );
        },
      ),
      floatingActionButton: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              getForm();
            },
            label: Text(
              "Add",
              style: TextStyle(fontSize: 20),
            ),
            icon: Icon(Icons.add),
          ),
          SizedBox(height: 20),
          FloatingActionButton.extended(
            heroTag: null,
            onPressed: () {
              setState(() {
                databaseReference = fb.reference();
              });
            },
            label: Text(
              "Refresh",
              style: TextStyle(fontSize: 20),
            ),
            icon: Icon(Icons.refresh),
          ),
        ],
      ),
    );
  }

  getForm() {
    final ref = fb.reference();
    showDialog(
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: AlertDialog(
            title: Text("Database"),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    autofocus: true,
                    controller: _nameController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Your Name First.......";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        name = val!;
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Name",
                      hintText: "Enter Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _ageController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Your Name First.......";
                      }
                      if (int.tryParse(val) == null) {
                        return "Please Enter Valid Age.......";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        age = int.parse(val!);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Age",
                      hintText: "Enter Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _rollNumberController,
                    textInputAction: TextInputAction.done,
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Enter Your Name First.......";
                      }
                      if (int.tryParse(val) == null) {
                        return "Please Enter Valid Age.......";
                      }
                      return null;
                    },
                    onSaved: (val) {
                      setState(() {
                        rollNumber = int.parse(val!);
                      });
                    },
                    decoration: InputDecoration(
                      labelText: "Roll Number",
                      hintText: "Enter RollNumber",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                ],
              ),
            ),
            actions: [
              OutlinedButton(
                onPressed: () {
                  _rollNumberController.clear();
                  _nameController.clear();
                  _ageController.clear();
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    ref.child("Data").push().set(<String, dynamic>{
                      "id": id++,
                      "name": name,
                      "age": age,
                      "rollNumber": rollNumber
                    });
                    _rollNumberController.clear();
                    _nameController.clear();
                    _ageController.clear();
                    Navigator.of(context).pop();
                  }
                },
                child: Text("Submit"),
              ),
            ],
          ),
        );
      },
    );
  }
}
