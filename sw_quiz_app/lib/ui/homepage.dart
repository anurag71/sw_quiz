import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

//TODO: Get level from Firebase and update score

class _HomePageState extends State<HomePage> {

  var _loaded = false;
  var _last = false;
  var radioValue = 0;
  var qno = 0;
  var finalScore =0;
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  var _level;
  static List<String> questions = new List();
  static List<List<String>> anschoice = new List();
  static List<String> answers = new List();


  getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _level = prefs.getInt("level") ?? 1;

    List<DocumentSnapshot> list;
    CollectionReference collectionReference = Firestore.instance.collection("levels/njo6yAWcxYnIRzmVL1G9/"+_level.toString());
    QuerySnapshot querySnapshot = await collectionReference.getDocuments();

    list = querySnapshot.documents;
    // ignore: sdk_version_set_literal
    list.forEach((DocumentSnapshot snap) => {
      questions.add(snap.data["ques"]),
      anschoice.add(List.of([snap.data["A"],snap.data["B"],snap.data["C"],snap.data["D"]])),
      answers.add(snap.data["ans"]),
    });

    print(questions);
    print(anschoice);
    print(answers);

    setState((){
      _loaded = true;

    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
    //setData();
//    print(questions);
  }



  @override
  Widget build(BuildContext context) {

    final title = Theme.of(context).textTheme.title;
    final subtitle = Theme.of(context).textTheme.subtitle;
    final display1 = Theme.of(context).textTheme.display1;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    checkQuestion();
    if(_loaded) {
      return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text('Sw_Quiz'),
            backgroundColor: Colors.redAccent,
            centerTitle: true,
          ),
          body: Column(
            // mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              //score
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "User: ",
                          style: title,
                        ),
                        Text("SwTech", style: subtitle),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Text(
                          "Score: ",
                          style: title,
                        ),
                        Text(
                          "$finalScore",
                          style: subtitle,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 30.0,
              ),
              // Level
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Level: ",
                      style: display1,
                    ),
                    Text(
                      _level.toString(),
                      style: display1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.0,
              ),
              // Question number
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Question ${qno + 1} of ${questions.length}",
                  style: subtitle,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // question
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.topLeft,
                child: Text(
                  questions[qno],
                  style: title,
                ),
              ),
              //options
              choices(anschoice[qno][0], 0, radioValue),
              choices(anschoice[qno][1], 1, radioValue),
              choices(anschoice[qno][2], 2, radioValue),
              choices(anschoice[qno][3], 3, radioValue),
              //Next or Submit buttons
              button(),
                  ],
                ),

              ),
        );
    }
    else{
      return Scaffold(
        body: Center(
          child: Text("Loading",style: TextStyle(
            fontSize:20
          ),),
        ),
      );
    }
  }

  Widget choices(String choice, int value, int radioValue) {
    return Container(
      // padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Radio<int>(
            activeColor: Colors.redAccent,
            value: value,
            groupValue: radioValue,
            onChanged: handleRadioBtnChanged,
          ),
          Text(
            choice,
            style: Theme.of(context).textTheme.subtitle,
          ),
        ],
      ),
    );
  }

  Widget button(){
  if(!_last) {
    return
      Container(
        padding: const EdgeInsets.all(2.0),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100.0),
            color: Colors.red),
        child: MaterialButton(
            minWidth: 200.0,
            child: Text("Next", style: _btnStyle()),
            onPressed: () {
              if (checkAnswer()) {
                setState(() {
                  qno++;
                });
              }
            }
        ),
      );
  }
   else {
     return Container(
      padding: const EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          color: Colors.red),
      child: MaterialButton(
        minWidth: 200.0,
        child: Text("Submit", style: _btnStyle()),
        onPressed: () {
          if (checkAnswer()) {
            refresh();
          }
        },
      ),
    );
            // updateQuestion();
    }
  }

  bool checkAnswer(){
    if (anschoice[qno][radioValue] ==
        answers[qno]) {
      finalScore++;
      return true;
    } else {
      debugPrint("Wrong");
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text("Wrong answer! Correct answer is "+answers[qno]),
                  Text("Please select right choice to continue.")
                ],
              ),
            ],
          ),

        ),
      );
      return false;
    }
  }

  _btnStyle() {
    return TextStyle(
      color: Colors.white,
    );
  }

  void handleRadioBtnChanged(int value) {
    setState(() {
      radioValue = value;
    });
  }

  void checkQuestion() {
    setState(() {
      if (qno == questions.length-1) {
        _last = true;
      }
    });
  }

  refresh() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    finalScore =_level *10;
    setState(() {
    //prefs.setInt("level", _level++);
    });
  }
}