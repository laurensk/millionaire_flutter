import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:millionaire/data/quetions.dart';
import 'package:millionaire/models/question.dart';
import 'package:millionaire/models/questionAnswers.dart';
import 'package:millionaire/results.dart';

class Game extends StatefulWidget {
  final int answeredQuestions;
  final int correctQuestions;

  Game({this.answeredQuestions, this.correctQuestions});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> {
  List<Question> questions;
  Question question;
  QuestionAnswers correctAnswer;

  static int answeredQuestions;

  @override
  void initState() {

    questions = Questions.getQuestions();
    question = questions[widget.answeredQuestions];
    correctAnswer = question.answers[question.correctAnswer];
    question.answers.shuffle();

    answeredQuestions = widget.answeredQuestions;

    super.initState();
  }

  void nextView(bool wasAnswerCorrect) {
    if (widget.answeredQuestions >= 4) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Results(
                    answeredQuestions: widget.answeredQuestions + 1,
                    correctQuestions: wasAnswerCorrect
                        ? widget.correctQuestions + 1
                        : widget.correctQuestions,
                  )));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => Game(
                    answeredQuestions: widget.answeredQuestions + 1,
                    correctQuestions: wasAnswerCorrect
                        ? widget.correctQuestions + 1
                        : widget.correctQuestions,
                  )));
    }
  }

  void showAnswerAlert(bool wasAnswerCorrect) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return WillPopScope(
              onWillPop: () {
                return Future.value(false);
              },
              child: Dialog(
                  backgroundColor: Colors.transparent,
                  child: Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Stack(
                              overflow: Overflow.visible,
                              alignment: AlignmentDirectional.topCenter,
                              children: <Widget>[
                                Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 74,
                                        ),
                                        new Text(
                                          wasAnswerCorrect ? "Richtig!" : "Falsch!",
                                          style: TextStyle(
                                            fontFamily: "Brandon Text",
                                            fontWeight: FontWeight.w700,
                                            fontSize: 32,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 9,
                                        ),
                                        new Text(
                                          wasAnswerCorrect
                                              ? correctAnswer.answer +
                                                  "\nist die richtige Antwort!"
                                              : correctAnswer.answer +
                                                  "\nwäre die richtige Antwort gewesen.",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Helvetica Neue",
                                            fontSize: 15,
                                            color: Color(0xffffffff),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        new Container(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: <Widget>[
                                              GestureDetector(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  nextView(wasAnswerCorrect);
                                                },
                                                child: Text(
                                                  answeredQuestions <= 3 ? "Weiter" : "Zum Ergebnis",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          height: 42.00,
                                          width: 290.00,
                                          decoration: BoxDecoration(
                                            color: wasAnswerCorrect ? Color(0xffa7d22a) : Color(0xffE5001B),
                                            border: Border.all(
                                              width: 1.00,
                                              color: Color(0xffffffff),
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(8.00),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height: 230.00,
                                    width: 356.00,
                                    decoration: BoxDecoration(
                                      color: wasAnswerCorrect ? Color(0xff66bb00) : Color(0xffCC0000),
                                      borderRadius:
                                          BorderRadius.circular(15.00),
                                    )),
                                Positioned(
                                  top: -75,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Image.asset(
                                      wasAnswerCorrect ? "assets/alert/correct.png" : "assets/alert/incorrect.png",
                                      width: 100,
                                      height: 100,
                                    ),
                                  ),
                                ),
                              ]),
                        ]),
                  )));
        });
  }

  void answerSelected(int questionAnswerId) {
    if (question.correctAnswer == questionAnswerId) {
      showAnswerAlert(true);
    } else {
      showAnswerAlert(false);
    }
  }

  Widget answerBox(QuestionAnswers questionAnswer, String answerLabel) {
    return GestureDetector(
      onTap: () {
        answerSelected(questionAnswer.id);
      },
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Text(
              answerLabel,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.w500,
                fontSize: 23,
                color: Color(0xfffff500),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10),
            ),
            Text(
              questionAnswer.answer,
              style: TextStyle(
                fontFamily: "Helvetica Neue",
                fontWeight: FontWeight.w700,
                fontSize: 16,
                color: Color(0xffffffff),
              ),
            )
          ],
        ),
        height: 42.00,
        width: 320.00,
        decoration: BoxDecoration(
          color: Color(0xfffc9115),
          border: Border.all(
            width: 1.00,
            color: Color(0xffffffff),
          ),
          borderRadius: BorderRadius.circular(8.00),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: Image.asset(
              'assets/background.png',
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              fit: BoxFit.fill,
            ),
          ),
          Center(
            child: Center(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(36.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/logo/MLogo_HTL.png",
                        width: 133,
                        height: 133,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            "assets/joker/1.png",
                            width: 57,
                            height: 35,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 18),
                          ),
                          Image.asset(
                            "assets/joker/2.png",
                            width: 57,
                            height: 35,
                          ),
                          Padding(
                            padding: EdgeInsets.only(right: 18),
                          ),
                          Image.asset(
                            "assets/joker/3.png",
                            width: 57,
                            height: 35,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              "Frage " +
                                  (widget.answeredQuestions + 1).toString() +
                                  "/" +
                                  questions.length.toString(),
                              style: TextStyle(color: Colors.white),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                            ),
                            Text(
                              question.question,
                              style:
                                  TextStyle(fontSize: 19, color: Colors.white),
                            )
                          ],
                        ),
                        height: 169.00,
                        width: 310.00,
                        decoration: BoxDecoration(
                          color: Color(0xff2c016c),
                          border: Border.all(
                            width: 2.00,
                            color: Color(0xffffffff),
                          ),
                          borderRadius: BorderRadius.circular(10.00),
                        ),
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      answerBox(question.answers[0], "A:"),
                      SizedBox(
                        height: 14,
                      ),
                      answerBox(question.answers[1], "B:"),
                      SizedBox(
                        height: 14,
                      ),
                      answerBox(question.answers[2], "C:"),
                      SizedBox(
                        height: 14,
                      ),
                      answerBox(question.answers[3], "D:"),
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
