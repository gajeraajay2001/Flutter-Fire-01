import 'package:firebase_database/firebase_database.dart';

class DataModel {
  final String name;
  final int age;
  final int rollNumber;
  DataModel({
    required this.name,
    required this.age,
    required this.rollNumber,
  });

  DataModel.fromSnapshot(DataSnapshot snapshot)
      : name = snapshot.value["name"],
        age = snapshot.value["age"],
        rollNumber = snapshot.value["rollNumber"];

  toJson() {
    return {
      "name": name,
      "age": age,
      "rollNumber": rollNumber,
    };
  }
}
