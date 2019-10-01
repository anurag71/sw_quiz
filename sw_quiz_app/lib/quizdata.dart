import 'package:cloud_firestore/cloud_firestore.dart';

class Data {

  static var _level;
  static List<String> questions = new List();
  static List<List<String>> choices = new List();
  static List<String> answers = new List();


  static getData(index) async{
    List<DocumentSnapshot> list;
    CollectionReference collectionReference = Firestore.instance.collection("levels/njo6yAWcxYnIRzmVL1G9/$_level");
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();

    list = querySnapshot.documents;

    // ignore: sdk_version_set_literal
    list.forEach((DocumentSnapshot snap) => {

      questions.add(snap.data["ques"]),
      choices.addAll([snap.data["A"],snap.data["B"],snap.data["C"],snap.data["D"]]),
      answers.add(snap.data["ans"])
    });

    print(questions);
    print(choices);
    print(answers);
  }


}
