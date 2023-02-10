import 'package:flutter/material.dart';
import 'package:millionaire/game.dart';
import 'package:millionaire/utils/soundUtils.dart';
import 'package:url_launcher/url_launcher.dart';

class Results extends StatefulWidget {
  final int answeredQuestions;
  final int correctQuestions;

  Results({this.answeredQuestions, this.correctQuestions});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  static int correctQuestions;

  @override
  void initState() {
    correctQuestions = widget.correctQuestions;

    SoundUtils.playSound(Sounds.result);

    super.initState();
  }

  void _openKaindorfWebsite() async {
    const url = 'http://www.htl-kaindorf.at';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _startGame() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => Game(
                  answeredQuestions: 0,
                  correctQuestions: 0,
                  resetJoker: true,
                )));
  }

  Widget resultView(int correctQuestions) {
    bool wellDone;
    correctQuestions >= 3 ? wellDone = true : wellDone = false;

    return Column(children: <Widget>[
      Stack(
          clipBehavior: Clip.none,
          // overflow: Overflow.visible,
          alignment: AlignmentDirectional.topCenter,
          children: <Widget>[
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 74,
                  ),
                  new Text(
                    wellDone ? "Gratulation!" : "Schade!",
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: Color(0xffffffff),
                    ),
                  ),
                  SizedBox(
                    height: 7,
                  ),
                  new Text(
                    "Sie haben",
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 15,
                      color: Color(0xffffffff),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  new Text(
                    correctQuestions.toString() +
                        "/" +
                        widget.answeredQuestions.toString(),
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontWeight: FontWeight.w700,
                      fontSize: 23,
                      color: Color(0xffffffff),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  new Text(
                    "Fragen richtig beantwortet",
                    style: TextStyle(
                      fontFamily: "Helvetica Neue",
                      fontSize: 15,
                      color: Color(0xffffffff),
                    ),
                  )
                ],
              ),
              height: 198.00,
              width: 292.00,
              decoration: BoxDecoration(
                color: wellDone ? Color(0xff66bb00) : Color(0xffCC0000),
                border: Border.all(
                  width: 1.00,
                  color: Color(0xffffffff),
                ),
                borderRadius: BorderRadius.circular(15.00),
              ),
            ),
            Positioned(
              top: -80,
              child: Container(
                margin: EdgeInsets.only(top: 40),
                child: Image.asset(
                  wellDone
                      ? "assets/alert/correct.png"
                      : "assets/alert/incorrect.png",
                  width: 100,
                  height: 100,
                ),
              ),
            ),
          ]),
    ]);
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
                  padding: const EdgeInsets.only(top: 20, left: 36, right: 36),
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
                        height: 80,
                      ),
                      resultView(widget.correctQuestions),
                      SizedBox(
                        height: 50,
                      ),
                      GestureDetector(
                        onTap: () {
                          _startGame();
                        },
                        child: Container(
                          child: Center(
                              child: Text(
                            "Erneut Spielen",
                            style: TextStyle(
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.w700,
                              fontSize: 25,
                              color: Color(0xffffffff),
                            ),
                          )),
                          height: 57.00,
                          width: 292.00,
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
                      SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          _openKaindorfWebsite();
                        },
                        child: Container(
                          child: Center(
                              child: Text(
                            "Über die HTBLA Kaindorf",
                            style: TextStyle(
                              fontFamily: "Helvetica Neue",
                              fontWeight: FontWeight.w500,
                              fontSize: 20,
                              color: Color(0xffffffff),
                            ),
                          )),
                          height: 57.00,
                          width: 292.00,
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
