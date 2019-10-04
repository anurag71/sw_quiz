import 'package:flutter/material.dart';
import 'package:sw_quiz_app/quizdata.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // var radioValue = -1;
  var radioValue = 0;
  var qno = 0;
  var finalScore = 0;
  var data = Data();
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    setState(() {
      radioValue = -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final title = Theme.of(context).textTheme.title;
    final subtitle = Theme.of(context).textTheme.subtitle;
    final display1 = Theme.of(context).textTheme.display1;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text('Sw_Quiz'),
          backgroundColor: Colors.redAccent,
          centerTitle: true,
        ),
        body: ListView(
          shrinkWrap: true,
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
                    "2",
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
                "Question ${qno + 1} of ${data.questions.length}",
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
                "Who is the Prime Minister of India?",
                style: title,
              ),
            ),
            //options
            choices(data.choices[qno][0], 0, radioValue),
            choices(data.choices[qno][1], 1, radioValue),
            choices(data.choices[qno][2], 2, radioValue),
            choices(data.choices[qno][3], 3, radioValue),
            //Next or Submit buttons
            Container(
              height: 300.0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.red),
                    child: MaterialButton(
                      minWidth: 200.0,
                      child: Text("Next", style: _btnStyle()),
                      onPressed: () {
                        if (data.choices[qno][radioValue] ==
                            data.answers[qno]) {
                          debugPrint("correct");
                          finalScore++;
                          updateQuestion();
                        } else {
                          debugPrint("Wrong");
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content:
                                  Text("You have selected the wrong answer!"),
                            ),
                          );
                        }
                        // updateQuestion();
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("OR"),
                  ),
                  Container(
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100.0),
                        color: Colors.red),
                    child: MaterialButton(
                      minWidth: 200.0,
                      child: Text("Submit", style: _btnStyle()),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ResultPage(score: "$finalScore")));
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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

  void updateQuestion() {
    setState(() {
      if (qno == data.questions.length - 1) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ResultPage(score: "$finalScore")));
      } else {
        qno++;
        // set the radio value to -1 inorder to uncheck the value by default
        radioValue = -1;
      }
    });
  }
}

class ResultPage extends StatelessWidget {
  ResultPage({this.score});
  final score;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Text(
          "Final Score $score",
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 30.0),
        ),
      ),
    );
  }
}
