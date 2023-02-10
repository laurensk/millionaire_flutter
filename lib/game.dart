import 'dart:math';

import 'package:flutter/material.dart';
import 'package:millionaire/data/jokers.dart';
import 'package:millionaire/data/quetions.dart';
import 'package:millionaire/models/question.dart';
import 'package:millionaire/models/questionAnswers.dart';
import 'package:millionaire/results.dart';
import 'package:millionaire/utils/alertUtils.dart';
import 'package:millionaire/utils/soundUtils.dart';

class Game extends StatefulWidget {
  final int answeredQuestions;
  final int correctQuestions;
  final bool resetJoker;

  Game({this.answeredQuestions, this.correctQuestions, this.resetJoker});

  @override
  _GameState createState() => _GameState();
}

class _GameState extends State<Game> with TickerProviderStateMixin {
  List<Question> questions;
  Question question;
  QuestionAnswers correctAnswer;
  var _random = new Random();

  Map<int, bool> hideMap = {0: false, 1: false, 2: false, 3: false};

  static int answeredQuestions;

  AnimationController animationController;
  Animation<double> animation;

  @override
  void initState() {
    questions = Questions.getQuestions();
    question = questions[widget.answeredQuestions];
    correctAnswer = question.answers[question.correctAnswer];
    question.answers.shuffle();

    SoundUtils.playSound(Sounds.question);

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1100),
    )..addListener(() => setState(() {}));
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.easeInOut,
    );

    animationController.forward();

    answeredQuestions = widget.answeredQuestions;

    if (widget.resetJoker) {
      setState(() {
        Jokers.jokers.forEach((f) {
          f.wasActivated = false;
        });
      });
    }

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
                    resetJoker: false,
                  )));
    }
  }

  void jokerSelected(int id) {
    if (Jokers.jokers[id].id == 0) {
      fiftyFiftyJoker();
    } else if (Jokers.jokers[id].id == 1) {
      audienceJoker();
    } else if (Jokers.jokers[id].id == 2) {
      telephoneJoker();
    }
  }

  void jokerAlreadyUsed(int id) {
    AlertUtils.showAlert(
        context,
        "Bereits eingesetzt",
        "Dieser Joker wurde bereits eingesetzt\nund ist nicht mehr verfügbar.",
        "assets/alert/incorrect.png",
        "Schließen",
        Color(0xffBE0001),
        Color(0xffD22A2B));
  }

  void audienceJoker() {
    SoundUtils.playSound(Sounds.audiencePhone);
    AlertUtils.showAlert(
        context,
        "Publikumsjoker",
        "Frage jemanden um dich,\num die Antwort zu erfahren.",
        "assets/logo/MLogo_HTL.png",
        "Erledigt",
        Color(0xffD37203),
        Color(0xffFD9014));
  }

  void telephoneJoker() {
    SoundUtils.playSound(Sounds.audiencePhone);
    AlertUtils.showAlert(
        context,
        "Telefonjoker",
        "Frage jemanden um dich,\num die Antwort zu erfahren.",
        "assets/logo/MLogo_HTL.png",
        "Erledigt",
        Color(0xffD37203),
        Color(0xffFD9014));
  }

  void fiftyFiftyJoker() {
    _random = Random();

    SoundUtils.playSound(Sounds.fiftyFifty);

    int correctAnswerId;

    for (int i = 0; i < question.answers.length; i++) {
      if (question.answers[i].id == correctAnswer.id) {
        correctAnswerId = i;
      }
    }

    print("correctAnswerId: " + correctAnswerId.toString());

    var firstNumberToHide = 0 + _random.nextInt(3 - 0);
    var secondNumberToHide = 0 + _random.nextInt(3 - 0);

    while (firstNumberToHide == correctAnswerId ||
        secondNumberToHide == correctAnswerId ||
        firstNumberToHide == secondNumberToHide) {
      firstNumberToHide = 0 + _random.nextInt(3 - 0);
      secondNumberToHide = 0 + _random.nextInt(3 - 0);
    }

    print("first number:" + firstNumberToHide.toString());
    print("second number:" + secondNumberToHide.toString());

    hideMap = {0: false, 1: false, 2: false, 3: false};

    if (firstNumberToHide == 0 || secondNumberToHide == 0) {
      hideMap[0] = true;
    }

    if (firstNumberToHide == 1 || secondNumberToHide == 1) {
      hideMap[1] = true;
    }

    if (firstNumberToHide == 2 || secondNumberToHide == 2) {
      hideMap[2] = true;
    }

    if (firstNumberToHide == 3 || secondNumberToHide == 3) {
      hideMap[3] = true;
    }

    print(hideMap.toString());

    setState(() {});
  }

  Widget joker(int id) {
    return GestureDetector(
      onTap: () {
        if (Jokers.jokers[id].wasActivated) {
          jokerAlreadyUsed(Jokers.jokers[id].id);
        } else {
          Jokers.jokers[id].wasActivated = true;
          setState(() {});
          jokerSelected(id);
        }
      },
      child: Opacity(
        child: Image.asset(
          "assets/joker/${id + 1}.png",
          width: 57,
          height: 35,
        ),
        opacity: Jokers.jokers[id].wasActivated ? 0.3 : 1.0,
      ),
    );
  }

  void showAnswerAlert(bool wasAnswerCorrect) {
    wasAnswerCorrect
        ? SoundUtils.playSound(Sounds.correct)
        : SoundUtils.playSound(Sounds.incorrect);

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
                              clipBehavior: Clip.none,
                              // overflow: Overflow.visible,
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
                                          wasAnswerCorrect
                                              ? "Richtig!"
                                              : "Falsch!",
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
                                        GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                            nextView(wasAnswerCorrect);
                                          },
                                          child: Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                Text(
                                                  answeredQuestions <= 3
                                                      ? "Weiter"
                                                      : "Zum Ergebnis",
                                                  style: TextStyle(
                                                    fontFamily:
                                                        "Helvetica Neue",
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 22,
                                                    color: Color(0xffffffff),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            height: 42.00,
                                            width: 290.00,
                                            decoration: BoxDecoration(
                                              color: wasAnswerCorrect
                                                  ? Color(0xffa7d22a)
                                                  : Color(0xffE5001B),
                                              border: Border.all(
                                                width: 1.00,
                                                color: Color(0xffffffff),
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(8.00),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    height: 230.00,
                                    width: 356.00,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2.00,
                                        color: Color(0xffffffff),
                                      ),
                                      color: wasAnswerCorrect
                                          ? Color(0xff66bb00)
                                          : Color(0xffCC0000),
                                      borderRadius:
                                          BorderRadius.circular(15.00),
                                    )),
                                Positioned(
                                  top: -75,
                                  child: Container(
                                    margin: EdgeInsets.only(top: 40),
                                    child: Image.asset(
                                      wasAnswerCorrect
                                          ? "assets/alert/correct.png"
                                          : "assets/alert/incorrect.png",
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

  Widget answerBox(QuestionAnswers questionAnswer, String answerLabel, int id) {
    return AnimatedOpacity(
      child: GestureDetector(
        onTap: () {
          if (hideMap[id] != true) {
            answerSelected(questionAnswer.id);
          }
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
      ),
      opacity: hideMap[id] ? 0.3 : 1.0,
      duration: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
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
                        ScaleTransition(
                          scale: animation,
                          child: Image.asset(
                            "assets/logo/MLogo_HTL.png",
                            width: 133,
                            height: 133,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            joker(0),
                            Padding(
                              padding: EdgeInsets.only(left: 18),
                            ),
                            joker(1),
                            Padding(
                              padding: EdgeInsets.only(right: 18),
                            ),
                            joker(2),
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
                                style: TextStyle(
                                    fontSize: 19, color: Colors.white),
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
                          height: 30,
                        ),
                        answerBox(question.answers[0], "A:", 0),
                        SizedBox(
                          height: 14,
                        ),
                        answerBox(question.answers[1], "B:", 1),
                        SizedBox(
                          height: 14,
                        ),
                        answerBox(question.answers[2], "C:", 2),
                        SizedBox(
                          height: 14,
                        ),
                        answerBox(question.answers[3], "D:", 3),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
