import 'package:firebase_database/firebase_database.dart';
import 'package:flutterfire01/models/data_Model.dart';

class DatabaseService {
  Future<List<DataModel>> getData() async {
    List<DataModel> data = [];
    Query dataModelSnapShot =
        FirebaseDatabase.instance.reference().child("Data");
    print(dataModelSnapShot);
    dataModelSnapShot.once().then((DataSnapshot snapshot) {
      Map<String, dynamic> temp = snapshot.value.cast<String, dynamic>();
      temp.forEach((key, value) {
        print("$key => $value, ${value["name"]}");
        data.add(DataModel(
          name: value["name"],
          age: value["age"],
          rollNumber: value["rollNumber"],
        ));
      });
    });
    return data;
  }
}

DatabaseService databaseService = DatabaseService();
