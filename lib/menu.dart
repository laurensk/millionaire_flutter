import 'package:audioplayers/audio_cache.dart';
import 'package:flutter/material.dart';
import 'package:millionaire/utils/soundUtils.dart';

class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> with TickerProviderStateMixin {
  AnimationController rotationController;
  AnimationController opacityController;

  @override
  void initState() {
    rotationController =
        AnimationController(duration: const Duration(seconds: 6), vsync: this);
    rotationController.forward();
    opacityController =
        AnimationController(duration: const Duration(seconds: 3), vsync: this);
    opacityController.forward();
    SoundUtils.playSound(Sounds.appstart);

AudioCache audioCache = AudioCache();
    audioCache.play(Sounds.appstart);

    super.initState();
  }

  @override
  void dispose() {
    rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Center(
            child: new Image.asset(
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
                      FadeTransition(
                          opacity: opacityController.drive(CurveTween(curve: Curves.easeOut)),
                          child: Image.asset(
                            "assets/logo/htl.png",
                            height: 85,
                          )),
                      SizedBox(
                        height: 80,
                      ),
                      RotationTransition(
                          turns: Tween(begin: 0.5, end: 0.0).animate(
                              CurvedAnimation(
                                  parent: rotationController,
                                  curve: Curves.linearToEaseOut)),
                          child: Image.asset(
                            "assets/logo/MLogo_HTL.png",
                            height: 210,
                          )),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "Herzlich willkommen beim Tag der offenen Tür\nder HTBLA Kaindorf! Testen Sie in dieser App Ihr\nWissen über unsere Schule.",
                        style: TextStyle(color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 80,
                      ),
                      GestureDetector(
                        onTap: () {},
                        child: Container(
                          child: Center(
                              child: Text(
                            "Spielen",
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
                        onTap: () {},
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
