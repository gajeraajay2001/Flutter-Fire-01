import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire01/models/data_Model.dart';

class CloudFireStoreDBPage extends StatefulWidget {
  static const routes = "cloud_fire_store_db_page";
  @override
  _CloudFireStoreDBPageState createState() => _CloudFireStoreDBPageState();
}

class _CloudFireStoreDBPageState extends State<CloudFireStoreDBPage> {
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  late QuerySnapshot<Map<String, dynamic>> res;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _ageController = TextEditingController();
  TextEditingController _rollNumberController = TextEditingController();
  late DatabaseReference databaseReference;
  final fb = FirebaseDatabase.instance;

  int id = 1;
  String name = "";
  int age = 0, rollNumber = 0;
  @override
  void initState() {
    getData();

    databaseReference = fb.reference();
    super.initState();
  }

  getData() async {
    res = await firebaseFirestore.collection("users").get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cloud Fire Store Database"),
      ),
      body: FirebaseAnimatedList(
          query: databaseReference,
          itemBuilder: (context, DataSnapshot snapshot, animation, index) {
            List<DataModel> data = [];
            List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = res.docs;
            docs.forEach((element) {
              Map<String, dynamic> temp =
                  element.data().cast<String, dynamic>();
              data.add(DataModel(
                  name: temp["name"],
                  age: temp["age"],
                  rollNumber: temp["rollNumber"]));
            });
            print("data:= $data");
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
          }),
      floatingActionButton: Wrap(
        crossAxisAlignment: WrapCrossAlignment.end,
        direction: Axis.vertical,
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
            onPressed: () async {
              QuerySnapshot<Map<String, dynamic>> res =
                  await firebaseFirestore.collection("users").get();
              List<QueryDocumentSnapshot<Map<String, dynamic>>> docs = res.docs;
              docs.forEach((element) {
                print(element.data());
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

                    await firebaseFirestore
                        .collection("users")
                        .doc("${id++}")
                        .set({
                      "name": name,
                      "age": age,
                      "rollNumber": rollNumber,
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
